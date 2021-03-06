module ApplicationHelper

  #TODO potřebuju asset_host helper?
  def asset_host
    case Rails.env
    when "development"
      host = "http://localhost:#{ENV['LOCAL_PORT']}/"
    when "stage"
      host = "http://stage.givit.cz/"
    when "production"
      host = "https://www.givit.cz/"
    end
  end

  def __environment__
    ["stage", "test", "development"].include?(Rails.env) ? Rails.env : ""
  end

  def user_type
    current_user ? current_user.role : "no_auth"
  end

  def page_title
    "Givit - dárky, které opravdu potěší"
  end

  def list_type
    @list ? @list.occasion_name : ""
  end

  def original_controller(origin)
  hidden_field_tag :origin, value: origin ||= Rails.application.routes.recognize_path(request.original_url, method: :post)[:action] if origin != nil && origin == "new"
  hidden_field_tag :origin, value: origin ||= Rails.application.routes.recognize_path(request.original_url)[:action]
  end

  def ga_user_id
    hidden_field_tag 'ga_user_id', '', :class => 'ga_user_id'
  end

end
