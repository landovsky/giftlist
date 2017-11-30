class UrlsController < ApplicationController

  #TODO URLs: k událostem přidat kontext document location

  def open
    url = Url.eager_load(:gift => :list).find_by(digest: params[:digest])
    GoogleAnalyticsApi.new.event('gifts', 'url opened', url.url_domain, 555, user_type: current_user.role, list_type: url.gift.list.occasion)
    redirect_to url.src
  end

  def create
    begin
      @data = LinkThumbnailer.generate(url_match(url_params[:data]))
    rescue Errno::EADDRNOTAVAIL, LinkThumbnailer::HTTPError, NoMethodError => error
      MyLogger.logme('LinkThumbnailer', 'chyba generování url', url: url_params[:data], error: error, level: 'warn')
      render 'create_error' and return
    end
    
    #TODO URLs zanořit vytvoření digestu do modelu Url
    @url = Url.new(data: @data.as_json, gift_id: url_params[:gift_id])
    @url.digest =  Digest::SHA1.hexdigest(url_match(url_params[:data]))
    @list = @url.gift.list #kvůli podmíněnému zobrazení ikony koše

    #TODO URLs udělat un-happy cestu když se to neuloží
    if !@url.save
      logger.debug @url.errors.messages
      @url = Url.find_by(digest: @url.digest)
    end
  end

  def destroy
    @url = Url.joins(:gift => :list).where( urls: {id: params[:id]}, lists: {user_id: current_user.id}).limit(1)
    if @url.empty?
      logger.debug "URL#destroy: supplied params not authentic"
      #TODO URLs return nezastaví zpracování a šablona hází chybu (nemá proměnnou)
      return
    else
      @url.first.destroy
      @url = @url.first #konverze ActiveRecord::Relation objektu do Url objektu
    end
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
