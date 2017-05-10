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
  
  def analytics_tracker
    case Rails.env
    when "stage"
      "UA-349441-6"
    when "production"
      "UA-349441-5"
    end
  end
  
end
