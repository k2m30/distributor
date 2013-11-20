require 'test_helper'

class LogMailerTest < ActionMailer::TestCase
  test "update_report" do
    mail = LogMailer.update_report
    assert_equal "Update report", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
