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
end
