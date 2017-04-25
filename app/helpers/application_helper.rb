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

end
