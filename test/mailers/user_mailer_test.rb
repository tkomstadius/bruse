require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "welcome" do
    # Send the email, then test that it got queued
    email = UserMailer.welcome(users(:fooBar)).deliver_now
    assert_not ActionMailer::Base.deliveries.empty?

    # Test the body of the sent email contains what we expect it to
    assert_equal ['hello@bruse.io'], email.from
    assert_equal [users(:fooBar).email], email.to
    assert_equal "Welcome to Bruse.io", email.subject
  end
end
