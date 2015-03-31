require 'test_helper'

class FilesControllerTest < ActionController::TestCase
  # test "denies user to add files if logged out" do
  #   get :new, {identity_id: identities(:one).id}, {user_id: nil}

    assert_response :found
    assert_redirected_to root_url
  end

  test "denies user to add files if it is not their identity" do
    get :new, {identity_id: identities(:one).id}, {user_id: users(:arbar).id}

    assert_response :found
    assert_redirected_to root_url
  end

  test "deletes existing file" do
    assert_difference('BruseFile.count', -1) do
      delete :destroy, { format: 'json', identity_id: identities(:one).id, id: bruse_files(:one) },
        { user_id: users(:fooBar).id }
    end
  end

  test "should fail deleting existing file since identity is wrong" do
    assert_difference('BruseFile.count', 0) do
      # wrong identity!
      delete :destroy, { format: 'json', identity_id: identities(:two).id, id: bruse_files(:one) },
        { user_id: users(:fooBar).id }
    end
  end

  test "should fail deleting existing file since its not the user's" do
    assert_difference('BruseFile.count', 0) do
      # wrong identity!
      delete :destroy, { format: 'json', identity_id: identities(:one).id, id: bruse_files(:one) },
        { user_id: users(:arbar).id }
    end
  end

  test "should create file" do
    assert_difference('BruseFile.count') do
      post :create, {
          file: { name: 'image.jpg', foreign_ref: '/path/to/image.jpg', filetype: 'image/jpg' },
          format: 'json',
          identity_id: identities(:one).id
        },
        { user_id: users(:fooBar).id }
    end
  end

  test "should fail creating file" do
    assert_difference('BruseFile.count', 0) do
      # name missing
      post :create, {
          file: { filetype: 'image/jpg' },
          format: 'json',
          identity_id: identities(:one).id
        },
        { user_id: users(:fooBar).id }
    end
  end
end
