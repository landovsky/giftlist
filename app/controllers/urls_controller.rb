class UrlsController < ApplicationController
  
  def create
    #TODO ošetřit situaci kdy se nevygeneruje objekt (což způsobí problémy při rendrování)
    @data = LinkThumbnailer.generate(url_match(url_params[:data]))
   
    #TODO zanořit vytvoření digestu do modelu Url
    @url = Url.new(data: @data.as_json, gift_id: url_params[:gift_id])
    @url.digest =  Digest::SHA1.hexdigest(url_match(url_params[:data]))
    
    #TODO udělat un-happy cestu když se to neuloží
    @url.save
  end

  def destroy
    @url = Url.find_by(id: params[:id])
    @url.destroy
  end

  private

  def url_match(url)
    if !url.match(/^http[s]*:\/\//i)
      url = "http://" << url
    else
    url
    end
  end

  private
  def url_params
    params.require(:url).permit(:data, :digest, :id, :gift_id)
  end

end
