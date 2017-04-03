class ListDecorator < Draper::Decorator
 delegate_all
     
  def invitations_button_label
    if object.donors.count == 0
      "pozvat dárce"
    else
      "dárci (#{object.donors.count})"
    end
  end
  
end
