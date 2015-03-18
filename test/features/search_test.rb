require "test_helper"
require "rack_session_access/capybara"
include Capybara::Angular::DSL

class SearchTest < Capybara::Rails::TestCase
  test "visits the search page" do
    page.set_rack_session(user_id: users(:fooBar).id)
    visit search_path
    assert page.has_content?("Sök")
  end
end

