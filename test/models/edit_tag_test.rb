require 'test_helper'
#require 'helpers/omniauth_helper'

class TagTest < ActiveSupport::TestCase
  test "edit tag added to a file" do
  	file = bruse_files(:one)
  	tag = Tag.create(:name => "cool")
  	file.tags.append(tag)
    assert_equal file.tags.first.name, tag.name
    assert_equal tag.bruse_file.first.name, file.name
    tag.name = "not cool"
    tag.save
    assert_equal tag.name, "not cool"
    assert_equal file.tags.first.name, tag.name
  end
end
