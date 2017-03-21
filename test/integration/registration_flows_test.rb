require 'test_helper'

class RegistrationFlowsTest < ActionDispatch::IntegrationTest

test "attempt to register with invalid details" do
  get "/signup"
  assert_response :success
 
  post "/users",
    params: { user: { email: "", name: "", password: ""} }
  assert_response :bad_request
end

test "attempt to register as existing user" do
  get "/signup"
  assert_response :success
 
  post "/users",
    params: { user: { email: "landovsky@gmail.com", name: "", password: ""} }
  assert_response :bad_request
end

test "attempt to register as new user" do
  get "/signup"
  assert_response :success
 
  post "/users",
    params: { user: { email: "neco@neco.xcom", name: "", password: "neco", password_confirmation: "neco"} }
  assert_response :redirect
  follow_redirect!
end

end
