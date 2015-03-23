require 'test_helper'
require 'helpers/omniauth_helper'

class IdentityTest < ActiveSupport::TestCase
  test "creates identity from oauth" do
    auth = dropbox_new
    identity = Identity.find_or_create_from_oauth(auth)

    assert_equal identity.uid, auth.uid
  end

  test "finds identity from oauth" do
    auth = dropbox_old
    identity = Identity.find_or_create_from_oauth(auth)

    assert_equal identity.uid, auth.uid
  end

  test "tries to create with unsufficient data" do
    auth = dropbox_new
    auth.delete :uid

    exception = assert_raises(ActiveRecord::RecordInvalid) { Identity.find_or_create_from_oauth(auth) }
    assert_equal( "Validation failed: Uid can't be blank", exception.message )
  end
end
