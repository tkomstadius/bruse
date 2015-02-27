require 'test_helper'
require 'helpers/omniauth_helper'

class UserTest < ActiveSupport::TestCase
  test "create from oauth" do
    num_users = User.count
    auth = OmniAuth.config.mock_auth[:dropbox_new]
    user = User.find_or_create_from_oauth(auth)
    user = User.find(user)

    assert_equal num_users+1, User.count
    assert_equal user["name"], auth["info"]["name"]
  end

  test "sign in user from oauth" do
    num_users = User.count
    auth = OmniAuth.config.mock_auth[:dropbox_old]
    user = User.find_or_create_from_oauth(auth)
    user = User.find(user)

    assert_equal num_users, User.count
    assert_equal user["name"], auth["info"]["name"]
  end

  test "tries to sign in without credentials" do
    user = User.find_or_create_from_oauth(nil)

    assert_nil user
  end
end
