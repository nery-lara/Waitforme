require 'test_helper'

class BusinessRejoinConferenceTest < ActiveSupport::TestCase

  test 'Connecting User Message' do
    start = BusinessRejoinConference.new
    assert_equal 'Your customer called using WaitForMe. We are connecting to the customer now', start.connecting_user
  end

end
