require 'test_helper'

class SearchControllerTest < ActionController::TestCase
  def files(response)
    ActiveSupport::JSON.decode(response.body)["files"]
  end

  before do
    BruseFile.bulk_update_fuzzy_name
    Tag.bulk_update_fuzzy_name
  end

  after do
    assert_response :success
    assert_template :find
  end

  test "fuzzy search for a file name" do
    response = post(:find, {:tags => [], :filetypes => [], :fuzzy => [bruse_files(:one).name], :format => :json}, { :user_id => users(:fooBar).id })
    assert_equal files(response).first["name"], bruse_files(:one).name
  end

  test "search with empty parameters" do
    response = post(:find, {:tags => [], :filetypes => [], :fuzzy => [], :format => :json}, { :user_id => users(:fooBar).id })
    assert_equal files(response), []
  end

  test "search for a filetype" do
    response = post(:find, {:tags => [], :filetypes => [bruse_files(:one).filetype], :fuzzy => [], :format => :json}, { :user_id => users(:fooBar).id })
    assert_equal files(response).first["name"], bruse_files(:one).name
  end

  test "search for a tag name" do
    response = post(:find, {:tags => [tags(:one).name], :filetypes => [], :fuzzy => [], :format => :json}, { :user_id => users(:fooBar).id })
    assert_equal files(response).first["name"], bruse_files(:one).name
  end

  test "trying to search for files that the user doesn't own" do
    response = post(:find, {:tags => [], :filetypes => [], :fuzzy => [bruse_files(:one).name], :format => :json}, { :user_id => users(:arbar).id })
    assert_equal files(response), []
  end

  test "search with several criterias" do
    response = post(:find, {:tags => [tags(:one).name], :filetypes => [bruse_files(:one).filetype], :fuzzy => [bruse_files(:one).name], :format => :json}, { :user_id => users(:fooBar).id })
    assert_equal files(response).first["name"], bruse_files(:one).name
  end
end
