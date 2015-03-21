require 'test_helper'

class SearchControllerTest < ActionController::TestCase
  before do
    BruseFile.bulk_update_fuzzy_name
    Tag.bulk_update_fuzzy_name
  end

  test "fuzzy search for a file name" do
    response = post(:find, {:tags => [], :filetypes => [], :fuzzy => [bruse_files(:one).name], :format => :json}, { :user_id => users(:fooBar).id })
    assert_includes response.body, bruse_files(:one).name
    assert_response :success
    assert_template :find
  end

  test "search with empty parameters" do
    response = post(:find, {:tags => [], :filetypes => [], :fuzzy => [], :format => :json}, { :user_id => users(:fooBar).id })
    assert_equal ActiveSupport::JSON.decode(response.body)["files"], []
    assert_response :success
    assert_template :find
  end

  test "search for a filetype" do
    response = post(:find, {:tags => [], :filetypes => [bruse_files(:one).filetype], :fuzzy => [], :format => :json}, { :user_id => users(:fooBar).id })
    assert_equal ActiveSupport::JSON.decode(response.body)["files"].first["name"], bruse_files(:one).name
    assert_response :success
    assert_template :find
  end
end
