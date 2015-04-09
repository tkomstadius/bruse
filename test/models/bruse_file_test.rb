require 'test_helper'

class BruseFileTest < ActiveSupport::TestCase
  test "creates bruseFile from oauth" do
    num_files = BruseFile.count
    bruseFile = BruseFile.new(:name        => 'test.jpg',
                              :meta        => 'yoo',
                              :filetype    => 'image/jpg',
                              :foreign_ref => '/path/to/test.jpg',
                              :identity    => identities(:one))
    bruseFile.save!
    assert_equal num_files+1, BruseFile.count
  end

  test "does not create duplicate file" do
    assert_difference('BruseFile.count', 1) do
      BruseFile.create(:name        => 'test.jpg',
                       :filetype    => 'image/jpg',
                       :foreign_ref => '/path/to/test.jpg',
                       :identity    => identities(:one))
      BruseFile.create(:name        => 'new_name.jpg',
                       :filetype    => 'image/jpg',
                       :foreign_ref => '/path/to/test.jpg',
                       :identity    => identities(:one))
    end
  end

  test "should fail creating file since identity is missing" do
    assert_difference('BruseFile.count', 0) do
      BruseFile.create(:name        => 'test.jpg',
                       :filetype    => 'image/jpg',
                       :foreign_ref => '/path/to/test.jpg')
    end
  end
end
