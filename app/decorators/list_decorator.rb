class ListDecorator < ApplicationDecorator
 delegate_all
     
  def invitations_button_label
    if object.donors.count == 0
      "pozvat dárce"
    else
      "dárci (#{object.donors.count})"
    end
  end

  def occasion_date_f
    occasion_date.strftime("%D") if occasion_date != nil
  end

  def occasion_types
    {"příležitost" => 0}.merge(List.occasions)
  end
  
end
