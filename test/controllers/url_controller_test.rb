require "test_helper"

describe UrlController do
  it "should get create" do
    get url_create_url
    value(response).must_be :success?
  end

  it "should get destroy" do
    get url_destroy_url
    value(response).must_be :success?
  end

end
