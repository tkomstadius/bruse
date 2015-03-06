require 'test_helper'
#require 'helpers/omniauth_helper'

class TagTest < ActiveSupport::TestCase
  test "add tag to file" do
  	file = bruse_files(:one)
  	tag = Tag.create(:name => "cool")
  	file.tags.append(tag)
    assert_equal file.tags.first.name, tag.name
    assert_equal tag.bruse_files.first.name, file.name
  end
end
