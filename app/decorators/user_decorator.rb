class UserDecorator < ApplicationDecorator
  delegate_all

  def donor_name
    if name.blank? || surname.blank?
      email
    else
      [name, surname, "(", email, ")"].join(' ')
    end
  end

  def display_name
      if object.registered?
        object.full_name
      else
        h.content_tag(:span, "dokončit registraci", class: "label label-warning label-lg")
      end
  end

end
