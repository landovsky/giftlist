module MyLogger
  def self.logme(topic="", msg="", options={})
    options[:level] ? level = options[:level] : level = "debug"
    content = "#{Time.new.localtime} MYLOGGER (#{level}), #{topic}: #{msg}: #{options.except(:level)} | #{caller[0]} / #{caller[1]}"
    Rails.logger.send(level, content)
    Rollbar.log(level, content)
  end
end
