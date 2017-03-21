require "test_helper"

describe ListsController do
  it "should get new" do
    get lists_new_url
    value(response).must_be :success?
  end

  it "should get create" do
    get lists_create_url
    value(response).must_be :success?
  end

  it "should get index" do
    get lists_index_url
    value(response).must_be :success?
  end

  it "should get show" do
    get lists_show_url
    value(response).must_be :success?
  end

end
