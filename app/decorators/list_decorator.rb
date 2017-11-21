class ListDecorator < ApplicationDecorator
  delegate_all
  decorates_association :gifts

  def invitations_button_label
    if object.invitees.count == 0
      "pozvat dárce"
    else
      "dárci (#{object.invitees.count})"
    end
  end

  def edit_button
    if object.owner?(h.current_user.id)
      "<span class=\"glyphicon glyphicon-pencil pull-right\"></span>".html_safe
    end
  end

  def occasion_date_f
    occasion_date.strftime("%D") if occasion_date != nil
  end

  def occasion_types
    {"k příležitosti" => 0}.merge(List.occasions)
  end

  def occasion_name
    if List.occasions[object.occasion] == 99
      occasion_data
    else
      object.occasion
    end
  end
  
  def owner_name(list_user_id = h.session_user)
    list_user_id == object.user_id ? occasion_of : owner.full_name 
  end
  
  def invitation_text_decorated(user_full_name=h.current_user.full_name)
    invitation_text.blank? ? "#{user_full_name} tě pozval/a do svého seznamu dárků k příležitosti #{occasion_name}." : invitation_text 
  end

end
