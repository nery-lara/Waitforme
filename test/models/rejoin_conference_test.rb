require 'test_helper'

class RejoinConferenceTest < ActiveSupport::TestCase
  test 'Redirect' do
    rejoin = RejoinConference.new
    assert_equal '/calls/check_wait_or_exit', rejoin.redirect
  end

  test 'HangupOnStar' do
    rejoin = RejoinConference.new
    assert_equal 'true', rejoin.hangupOnStar
  end

  test 'Action' do
    rejoin = RejoinConference.new
    assert_equal '/calls/confirm_wait', rejoin.action
  end

  test 'Request_method' do
    rejoin = RejoinConference.new
    assert_equal 'POST', rejoin.request_method
  end

  test 'Numdigits' do
    rejoin = RejoinConference.new
    assert_equal 1, rejoin.numdigits
  end
end
