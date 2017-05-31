class Url < ApplicationRecord
  #TODO zajistit automatické smazání Url při smazání dárku

  belongs_to :gift
  serialize :data

  validates :digest, uniqueness: { scope: :gift_id }
  def image_src
    if self.data[:images].blank?
    return false
    else
      @image_src = self.data[:images][0][:src]
    end
  end

  def url_host
    uri = URI.parse(self.src)
    uri = URI.parse("http://#{url}") if uri.scheme.nil?
    host = uri.host.downcase
    host.start_with?('www.') ? host[4..-1] : host
  end
  
  def url_domain
    nationals = ["cz", "sk", "pl"]
    h = self.url_host.split(".")
    nationals.include?(h.last) ? h.last(2).join(".") : url_host
  end

  def src
    self.data[:url]
  end

end
