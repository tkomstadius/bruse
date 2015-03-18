require 'test_helper'

class BruseFileTest < ActiveSupport::TestCase
  test "creates bruseFile from oauth" do
    num_files = BruseFile.count
    bruseFile = BruseFile.new(:name        => "test.jpg",
                              :meta        => "yoo",
                              :filetype    => 'image/jpg',
                              :foreign_ref => '/path/to/test.jpg')
    bruseFile.save!
    assert_equal num_files+1, BruseFile.count
  end
end
