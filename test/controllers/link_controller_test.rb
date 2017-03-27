require "test_helper"

describe LinkController do
  it "should get new" do
    get link_new_url
    value(response).must_be :success?
  end

end
