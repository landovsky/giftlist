module ApplicationHelper

  #TODO potřebuju asset_host helper?
  def asset_host
    case Rails.env
    when "development"
      host = "http://localhost:3000/"
    when "stage"
      host = "http://stage.givit.cz/"
    when "production"
      host = "http://www.givit.cz/"
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

end
