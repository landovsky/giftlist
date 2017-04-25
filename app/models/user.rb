class User < ApplicationRecord
  has_many :lists #ownership of GiftList
  has_many :invitations, through: :invitation_lists, :source => :list #invitation to GiftList
  #TODO prod cleanup: test dependent destroy
  #FIXME při smazání uživatele zajistit, že jeho ID nebude v Gift.user_id
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
  
  def token_for_list(options={})
    list_id = options[:list_id] if options[:list_id]
    interval = options[:interval] if options[:interval]
    interval ||= "months"
    n = options[:n] if options[:n]
    n ||= 6
    JsonWebToken.encode(user_id: self.id, list_id: list_id, exp: n.send(interval).from_now.to_i)
  end

  #TODO pomocná debug metoda
  def self.token_url(options = {})
    user_id = options[:user_id] if options[:user_id]
    list_id = options[:list_id] if options[:list_id]
    url ||= "http://localhost:3000/auth"
    "#{url}?t=#{User.find_by(id: user_id).token_for_list(list_id: list_id)}"
  end

  #TODO pomocná debug metoda
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

end
