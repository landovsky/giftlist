require 'rest_client'

class GoogleAnalyticsApi

  def event(category, action, label, value='', client_id)
    return unless GOOGLE_ANALYTICS_SETTINGS[:tracking_code].present?
    if client_id.blank?
      MyLogger.logme("no client id detected", client_id: client_id)
      return
    end

    params = {
      v: GOOGLE_ANALYTICS_SETTINGS[:version],
      tid: GOOGLE_ANALYTICS_SETTINGS[:tracking_code],
      cid: client_id,
      t: "event",
      ec: category,
      ea: action,
      el: label,
      ev: value
    }

    begin
      #response = RestClient.delay(strategy: :allow_duplicate).get(GOOGLE_ANALYTICS_SETTINGS[:endpoint], params: params, timeout: 4, open_timeout: 4)
      MyLogger.logme(params: params)
      response = RestClient.get(GOOGLE_ANALYTICS_SETTINGS[:endpoint], params: params, timeout: 4, open_timeout: 4)
      #return true
    rescue  RestClient::Exception => rex
      MyLogger.logme("server side analytics", errors: rex)
      return false
    end
  end

end  