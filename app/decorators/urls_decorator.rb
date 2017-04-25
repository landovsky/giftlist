class UrlsDecorator < ApplicationDecorator
  delegate_all

def url
  data[:url]
end  

end
