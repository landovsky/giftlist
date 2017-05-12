module MyLogger
  def self.logme(msg="", vars={}, level="debug")
    content = "MYLOGGER: #{caller[0]} / #{caller[1]}: #{vars}"
    Rails.logger.send(level, content)
  end
end