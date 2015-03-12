require 'test_helper'

class BruseFileTest < ActiveSupport::TestCase
  test "creates bruseFile from oauth" do
  	num_files = BruseFile.count
    bruseFile = BruseFile.new(:name => "test",
                              :filetype => "jpg",
    						              :meta => "yoo")
    bruseFile.save!
    assert_equal num_files+1, BruseFile.count
  end
end
