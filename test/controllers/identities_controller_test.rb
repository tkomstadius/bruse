require 'test_helper'
require 'helpers/users_helper'

class IdentitiesControllerTest < ActionController::TestCase
  test "destroys identity" do
    delete(:destroy,
          { 'id' => identities(:one).id },
          { 'user_id' => users(:fooBar).id }) # (method, params, session)
    assert_response :found
  end

  test "redirects when trying to destroy the last identity" do
    identities(:one).destroy
    delete(:destroy,
          { 'id' => identities(:two).id },
          { 'user_id' => users(:fooBar).id }) # (method, params, session)
    assert_redirected_to terminate_user_url
  end
end
