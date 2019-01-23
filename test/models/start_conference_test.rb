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

  test 'Method_request' do
    start = StartConference.new
    assert_equal 'POST', start.method_request
  end

  test 'Num_digits' do
    start = StartConference.new
    assert_equal 10, start.num_digits
  end
end
