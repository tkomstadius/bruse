require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "show method displays using the correct views" do
    get(:show, nil, { 'user_id' => users(:fooBar).id }) # (method, params, session)
    assert_template :show
    assert_template layout: "layouts/application"
    assert_response :success
  end

  test "destroys a user" do
    delete(:destroy, nil, { 'user_id' => users(:fooBar).id })
    assert_response :found
    assert_redirected_to root_url
    assert_nil session[:user_id]
    assert_equal flash[:notice], "Your account is now deleted. We hate to see you go! Remember, you are allways welcome back!"
  end
end
