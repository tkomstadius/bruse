require 'test_helper'
#require 'helpers/omniauth_helper'

class TagTest < ActiveSupport::TestCase
  test "add tag to files" do
  	file = bruse_files(:one)
  	file2 = bruse_files(:two)
  	tag = Tag.create(:name => "cool")
  	file.tags.append(tag)
  	file2.tags.append(tag)
    assert_equal file.tags.first.name, tag.name
    assert_equal file2.tags.first.name, tag.name
    assert_equal tag.bruse_files.second.name, file.name
    assert_equal tag.bruse_files.first.name, file2.name
  end
end