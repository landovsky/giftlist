require "test_helper"

describe GiftsController do
  it "should get index" do
    get gifts_index_url
    value(response).must_be :success?
  end

  it "should get new" do
    get gifts_new_url
    value(response).must_be :success?
  end

  it "should get create" do
    get gifts_create_url
    value(response).must_be :success?
  end

  it "should get show" do
    get gifts_show_url
    value(response).must_be :success?
  end

  it "should get grab" do
    get gifts_grab_url
    value(response).must_be :success?
  end

  it "should get release" do
    get gifts_release_url
    value(response).must_be :success?
  end

  it "should get destroy" do
    get gifts_destroy_url
    value(response).must_be :success?
  end

  it "should get edit" do
    get gifts_edit_url
    value(response).must_be :success?
  end

  it "should get update" do
    get gifts_update_url
    value(response).must_be :success?
  end

end
