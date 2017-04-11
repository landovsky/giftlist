class User < ApplicationRecord
  has_many :lists #ownership of GiftList
  has_many :invitations, through: :invitation_lists, :source => :list #invitation to GiftList
  #TODO prod cleanup: test dependent destroy
  has_many :invitation_lists, dependent: :destroy
  has_many :donations, :source => :gift
  

  has_secure_password
  
  enum role: { guest: 0, unconfirmed: 1, registered: 2, admin: 3 }

  validates :email, email: true
  validates :email, uniqueness: { message: "Uživatel s emailovou adresou %{value} už u nás existuje." }
  validates :email, length: { maximum: 200, message: "Email nesmí obsahovat víc než 200 znaků."}

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

  #TODO pomocná metoda
  def self.token_url(list_id, url)
    "#{url}?t=#{User.last.token_for_list(list_id)}"
  end

  def registered?
    role == "registered"
  end

end
