class UrlParser
  def self.host(url)
    url = URI.parse(url)
    url = URI.parse("http://#{url}") if url.scheme.nil?
    host = url.host.downcase
    host.start_with?('www.') ? host[4..-1] : host
  end
  
  def self.domain(url)
    self.host(url).split(".").last(2).join(".")
  end

  def self.match(url)
    if !url.match(/^http[s]*:\/\//i)
      url = "http://" << url
    else
    url
  end
  end
end