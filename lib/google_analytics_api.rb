require 'rest_client'

class GoogleAnalyticsApi

  def event(category, action, label, value='', client_id)
    return unless GOOGLE_ANALYTICS_SETTINGS[:tracking_code].present?
    if client_id.blank?
      MyLogger.logme("google analytics", "no Client ID detected", level: "warn")
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
    
    params.delete(:el) if label.empty?
    params.delete(:ev) if value.empty?

    begin
      #response = RestClient.delay(strategy: :allow_duplicate).get(GOOGLE_ANALYTICS_SETTINGS[:endpoint], params: params, timeout: 4, open_timeout: 4)
      MyLogger.logme("google analytics", "submitted params", params: params)
      response = RestClient.get(GOOGLE_ANALYTICS_SETTINGS[:endpoint], params: params, timeout: 4, open_timeout: 4)
      #return true
    rescue  RestClient::Exception => rex
      MyLogger.logme("google analytics", "hit report failed", level: "warn", errors: rex)
      return false
    end
  end

end  