class User < ApplicationRecord
  before_save :downcase_fields
  before_destroy :untake_gifts

  has_many :lists, dependent: :destroy                                  #ownership of GiftList
  has_many :invitations, through: :invitation_lists, :source => :list   #invitation to GiftList
  has_many :invitation_lists, dependent: :destroy
  has_many :donations, class_name: "Gift"

  has_secure_password

  enum role: { guest: 0, unconfirmed: 1, registered: 2, admin: 3 }

  validates :email, email: true
  validates :email, uniqueness: { message: "Tuto emailovou adresu už známe. Pokud tě někdo pozval do svého seznamu, přihlaš se do aplikace odkazem (přišel ti emailem), poté můžeš dokončit registraci a přihlašovat se heslem." }
  validates :email, length: { maximum: 200, message: "Email nesmí obsahovat víc než 200 znaků."}

  validates :password, presence: true

  validates :name, length: { maximum: 30, message: "Jméno nesmí obsahovat víc než 30 znaků."}
  validates :surname, length: { maximum: 60, message: "Příjmení nesmí obsahovat víc než 60 znaků."}

  validates :role, numericality: { only_integer: true }
  validates :role, presence: true

  def full_name
    if name.blank? || surname.blank?
      email
    else
      [name, surname].join(' ')
    end
  end

  def self.find_by_token( token_in, options={} )
    options[:event] ? event = options[:event] : event = "not specified"

    token = JsonWebToken.decode(token_in)

    if token == nil                   # neplatný token
      GoogleAnalyticsApi.new.event('users', '#{event} - failure', 'token', 555)
      MyLogger.logme("JWT DEBUG", "token #{event} failed", event: event, token: token_in, level: "warn")
      return false
    else                              # dohledání uživatele podle user.id z tokenu
      user = User.find_by_id(token[:user_id])
    end
  end

  def token_for_list(options={})
    #TODO tokeny: vytáhnout n.send(interval)... do JsonWebToken
    list_id = options[:list_id] if options[:list_id]
    options[:interval] ? interval = options[:interval] : interval ||= "months"
    options[:n] ? n = options[:n] : n ||= 6
    token = JsonWebToken.encode(user_id: self.id, list_id: list_id, exp: n.send(interval).from_now.to_i)
    token
  end

  #TODO pomocná debug metoda
  def self.token_url(options = {})
    user_id = options[:user_id] if options[:user_id]
    list_id = options[:list_id] if options[:list_id]
    "#{Rails.application.routes.url_helpers.auth_url}?t=#{User.find_by(id: user_id).token_for_list(list_id: list_id)}"
  end

  #TODO temp - pomocná debug metoda
  def self.donation_stats( options={} )
    user = find_by(options)
    donations = user.donations.where(user_id: user.id)
    puts "donations: #{donations.count}"
    donation_lists = List.joins(:gifts).where(gifts: {user_id: user.id}).uniq
    puts "donation's lists #{donation_lists.count}"
    out = {"donations" => donations, "donation_lists" => donation_lists}
  end

  def registered?
    role == "registered"
  end

  def self.recover_password(email)
    @user = User.find_by(email: email)
    if @user
      @token = @user.token_for_list(n: 30, interval: "minutes")
      UserMailer.delay(run_at: Time.current, strategy: :delete_previous_duplicate ).recover_password_email(@user, @token)
      return true
    else
      return false
    end
  end

  private

  def downcase_fields
    self.email.downcase!
  end

  def untake_gifts
    Gift.where(user_id: self.id).update_all(user_id: nil)
  end

end
