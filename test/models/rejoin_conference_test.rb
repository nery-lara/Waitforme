require 'test_helper'

class RejoinConferenceTest < ActiveSupport::TestCase
  test 'Redirect' do
    rejoin = RejoinConference.new
    assert_equal '/calls/rejoinconference', rejoin.redirect
  end

  test 'HangupOnStar' do
    rejoin = RejoinConference.new
    assert_equal 'true', rejoin.hangupOnStar
  end

  test 'Action' do
    rejoin = RejoinConference.new
    assert_equal '/calls/confirmwait', rejoin.action
  end

  test 'Request_method' do
    rejoin = RejoinConference.new
    assert_equal 'POST', rejoin.request_method
  end

  test 'Numdigits' do
    rejoin = RejoinConference.new
    assert_equal 2, rejoin.numdigits
  end
end
