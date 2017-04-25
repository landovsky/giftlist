class GiftDecorator < ApplicationDecorator
  delegate_all

  #TODO gift decorator se nepodařil dostat do take.js.erb takže jsem všechny metody dal do modelu. Opravit, nebo vyhodit gift_decorator
  def collapse_id
    "gift#{id}"
  end

  def container_id
    "gift_cont#{id}"
  end

  def panel_style
    if taken?
      "default"
    else
      "success"
    end
  end

  def taken_badge
    case taken?(h.session_user)
    when "self"
      "<span class=\"label label-success\" style=\"position: relative; left: 5px; bottom: 2px\">tvoje rezervace</span>".html_safe
    when true
      "<span class=\"label label-default\" style=\"position: relative; left: 5px; bottom: 2px\">zabráno</span>".html_safe
    end
  end

  def description_glyph
    if object.description != ""
      "<p><span class=\"glyphicon glyphicon-list\">&nbsp;</span>#{object.description}</p>".html_safe
    end
  end

  def price_range_glyph
    if object.price_range != ""
      "<p><span class=\"glyphicon glyphicon-question-sign\">&nbsp;</span>#{price_range}</p>".html_safe
    end
  end

end
