class UserDecorator < Draper::Decorator
  delegate_all

  def donor_name
     if name.blank? || surname.blank?
      email
    else
      [name, surname, "(", email, ")"].join(' ')
    end 
  end

end
