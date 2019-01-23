require 'test_helper'

class StartConferenceTest < ActiveSupport::TestCase
  test 'Message' do
    start = StartConference.new
    assert_equal 'Please enter the number you wish to call', start.message
  end

  test 'Endpoint' do
    start = StartConference.new
    assert_equal '/calls/dial', start.endpoint
  end

  test 'Request_method' do
    start = StartConference.new
    assert_equal 'POST', start.request_method
  end

  test 'Numdigits' do
    start = StartConference.new
    assert_equal 10, start.numdigits
  end
end
