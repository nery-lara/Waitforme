require 'test_helper'

class WaitForBusinessTest < ActiveSupport::TestCase

  test 'BusinessRejoinConference Endpoint' do
    start = WaitForBusiness.new
    assert_equal '/calls/business_rejoin_conference', start.business_rejoin_conference
  end

  test 'Post Request' do
    start = WaitForBusiness.new
    assert_equal 'POST', start.post
  end

  test 'Listen for Speech' do
    start = WaitForBusiness.new
    assert_equal 'speech', start.speech
  end

  test 'WaitForBusiness Endpoint' do
    start = WaitForBusiness.new
    assert_equal 'speech', start.speech
  end

end
