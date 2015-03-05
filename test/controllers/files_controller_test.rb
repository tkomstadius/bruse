require 'test_helper'

class FilesControllerTest < ActionController::TestCase
  test "denies user to add files if logged out" do
    get :new, {identity_id: identities(:one).id}, {user_id: nil}

    assert_response :found
    assert_redirected_to root_url
  end
end
