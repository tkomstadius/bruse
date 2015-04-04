require 'test_helper'
#require 'helpers/omniauth_helper'

class TagTest < ActiveSupport::TestCase
  test "add tag to file" do
  	file = bruse_files(:one)
  	tag = Tag.create(:name => "cool")
  	file.tags.append(tag)
    assert_equal file.tags.last.name, tag.name
    assert_equal tag.bruse_files.first.name, file.name
  end

  test "edit tag added to a file" do
    file = bruse_files(:one)
    tag = Tag.create(:name => "cool")
    file.tags.append(tag)
    assert_equal file.tags.last.name, tag.name
    assert_equal tag.bruse_files.first.name, file.name
    tag.name = "not cool"
    tag.save
    assert_equal tag.name, "not cool"
    assert_equal file.tags.last.name, tag.name
  end

  test "add tag to files" do
    file = bruse_files(:one)
    file2 = bruse_files(:two)
    tag = Tag.create(:name => "cool")
    file.tags.append(tag)
    file2.tags.append(tag)
    assert_equal file.tags.last.name, tag.name
    assert_equal file2.tags.last.name, tag.name
    assert_equal tag.bruse_files.second.name, file.name
    assert_equal tag.bruse_files.first.name, file2.name
  end
end
