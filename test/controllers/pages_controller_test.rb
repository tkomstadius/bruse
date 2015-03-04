require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test "renders home page" do
    get(:show, { 'page' => 'home' })
    assert_response :success
    assert_template :home
    assert_template layout: "layouts/application"
  end
end
