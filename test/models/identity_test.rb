require 'test_helper'
require 'helpers/omniauth_helper'

class IdentityTest < ActiveSupport::TestCase
  test "creates identity from oauth" do
    auth = OmniAuth.config.mock_auth[:dropbox_new]
    identity = Identity.find_or_create_from_oauth(auth)

    assert_equal identity.uid, auth.info.uid
  end

  test "finds identity from oauth" do
    auth = OmniAuth.config.mock_auth[:dropbox_old]
    identity = Identity.find_or_create_from_oauth(auth)

    assert_equal identity.uid, auth.info.uid
  end
end
