class JsonWebToken
  class << self
    def encode(payload, exp = 24.hours.from_now)
      payload[:exp] ||= exp.to_i
      key = ENV["SECRET_KEY_BASE"]
      JWT.encode(payload, key)
    end

    def decode(token)
      HashWithIndifferentAccess.new body
    rescue
      nil
    end
  end
end