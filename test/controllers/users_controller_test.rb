require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get users_path
    assert_response :success
  end

  test "should get show" do
    get users_path(:id)
    assert_response :success
  end

  test "should get new" do
    get '/signup'
    assert_response :success
  end

  test "should get create" do
    post users_path params: {user: { email: "neco@neco.nec", password: "ahoj" }}
    assert_response :redirect
  end

end
