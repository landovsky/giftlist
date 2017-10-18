class JsonWebToken
  class << self
    def encode(payload, exp = 24.hours.from_now)
      payload[:exp] ||= exp.to_i
      #key = ENV["SECRET_KEY_BASE"]
      key = Rails.application.secrets.secret_key_base
      raise 'Key missing' unless key
      raise 'payload missing' unless payload
      JWT.encode(payload, key)
    end

    def decode(token)
      body = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
      HashWithIndifferentAccess.new body
    rescue
      nil
    end

    def expires(token)
      decoded = self.decode(token)
      return false unless decoded
      puts "expires #{DateTime.strptime(decoded[:exp].to_s, '%s')}"
      puts decoded
    end

    def expired?(token)
      decoded = self.decode(token)
      return true unless decoded
      DateTime.strptime(decoded[:exp].to_s, '%s').utc < Time.current.utc
    end
  end
end
