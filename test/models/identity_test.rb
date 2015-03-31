require 'test_helper'
require 'helpers/omniauth_helper'

class IdentityTest < ActiveSupport::TestCase
  test "creates identity from oauth" do
    auth = dropbox_new
    identity = Identity.find_or_create_from_oauth(auth)

    assert_equal identity.uid, auth.info.uid
  end

  test "finds identity from oauth" do
    auth = dropbox_old
    identity = Identity.find_or_create_from_oauth(auth)

    assert_equal identity.uid, auth.info.uid
  end

  test "tries to create with unsufficient data" do
    auth = dropbox_new
    auth.info.delete :uid

    exception = assert_raises(ActiveRecord::RecordInvalid) { Identity.find_or_create_from_oauth(auth) }
    assert_equal( "Validation failed: Uid can't be blank", exception.message )
  end

  test "creates brusefile using the current identity's add_file method" do
    assert_difference('BruseFile.count', 1) do
      file_params = { name: 'test.jpg', foreign_ref: 'path/to/test.jpg', filetype: 'image/jpg' }
      identities(:one).add_file(file_params)
    end
  end
end
