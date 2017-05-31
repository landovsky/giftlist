require 'rest_client'

class GoogleAnalyticsApi

  def event(category, action, label, client_id, options={})
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
      el: label
    }
    
    params[:dl] = options[:location] if options[:location]
    params[:ev] = options[:value] if options[:value]
    params[:cd1] = options[:user_type] if options[:user_type]
    params[:cd2] = options[:list_type] if options[:list_type]

    begin
      MyLogger.logme("google analytics", "submitted params", params: params.to_query)
      RestClient.delay(strategy: :allow_duplicate).get(GOOGLE_ANALYTICS_SETTINGS[:endpoint], params: params, timeout: 4, open_timeout: 4)
    rescue  RestClient::Exception => rex
      MyLogger.logme("google analytics", "hit report failed", level: "warn", errors: rex)
      return false
    end
  end

end  