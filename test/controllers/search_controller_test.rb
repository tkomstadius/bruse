require 'test_helper'

class SearchControllerTest < ActionController::TestCase
  test "search for a tag" do
    post(:find, {:tags => [tags(:one).name], :filetypes => [], :fuzzy => [], :format => :json}, { :user_id => users(:fooBar).id })
    assert_response :success
    assert_template :find
  end
end
