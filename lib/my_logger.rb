module MyLogger
  def self.logme(topic="", msg="", options={})
    options[:level] ? level = options[:level] : level = "debug"
    time = Time.new.localtime
    content = "#{topic}: #{msg}: #{options.except(:level)} | #{caller[0]} / #{caller[1]}"
    Rails.logger.send(level, "#{time} MYLOGGER (#{level}) #{content}")
    Rollbar.log(rollbar_level(level), content) unless level == "unknown"
  end

  private
  def self.rollbar_level(level)
    levels = {
      "warn" => "warning",
      "debug" => "debug",
      "info" => "info",
      "error" => "error",
      "fatal" => "critical"
    }
    levels[level]
  end

end
