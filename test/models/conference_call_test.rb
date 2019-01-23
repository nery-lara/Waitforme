require 'test_helper'

class ConferenceCallTest < ActiveSupport::TestCase 
  test 'Muted' do
    conference = ConferenceCall.new
    assert_equal 'False', conference.muted
  end

  test 'Beep' do
    conference = ConferenceCall.new
    assert_equal 'False', conference.beep
  end

  test 'StatusCallbackEvent' do
    conference = ConferenceCall.new
    assert_equal 'join leave', conference.statusCallbackEvent
  end

  test 'StatusCallback' do
    conference = ConferenceCall.new
    assert_equal '/calls/conference', conference.statusCallback
  end

  test 'StatusCallbackMethod' do
    conference = ConferenceCall.new
    assert_equal 'POST', conference.statusCallbackMethod
  end
end
