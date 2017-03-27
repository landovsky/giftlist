class LinkController < ApplicationController
skip_before_action :authorize

def new
  @object = LinkThumbnailer.generate(params[:url])
end

def status
  payload = {
  message: "OK",
  status: 200
}
render :json => payload, :status => :success
end

end
