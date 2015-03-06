require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "show method displays using the correct views" do
    get(:show, nil, { 'user_id' => users(:fooBar).id }) # (method, params, session)
    assert_template :show
    assert_template layout: "layouts/application"
    assert_response :success
  end
end
