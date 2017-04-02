class User < ApplicationRecord
  has_many :lists #ownership of GiftList
  has_many :invitations, through: :invitation_lists, :source => :list #invitation to GiftList
  has_many :invitation_lists
  has_many :donations, :source => :gift

  has_secure_password
  
  enum role: { guest: 0, unconfirmed: 1, registered: 2, admin: 3 }

  validates :email, presence: { message: "Vyplňte emailovou adresu." }
  validates :email, uniqueness: { message: "Uživatel s emailovou adresou %{value} už u nás existuje." }
  validates :email, length: { maximum: 200, message: "Email nesmí obsahovt víc než 200 znaků."}

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

end
