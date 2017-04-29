class JsonWebToken
  class << self
    def encode(payload, exp = 24.hours.from_now)
      payload[:exp] ||= exp.to_i
      key = ENV["SECRET_KEY_BASE"]
      Rails.logger.warn "#{self}: #{__method__}: JWT debug: key: #{key}"
      JWT.encode(payload, key)
    end

    def decode(token)
      body = JWT.decode(token, ENV["SECRET_KEY_BASE"])[0]
      HashWithIndifferentAccess.new body
    rescue
      nil
    end
  end
end