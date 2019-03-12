require 'test_helper'

class WaitForBusinessTest < ActiveSupport::TestCase

  test 'BusinessRejoinConference Endpoint' do
    name = 'user'
    start = WaitForBusiness.new(name)
    assert_equal '/calls/business_rejoin_conference/user', start.business_rejoin_conference
  end

  test 'Post Request' do
    name = 'user'
    start = WaitForBusiness.new(name)
    assert_equal 'POST', start.post
  end

  test 'Listen for Speech' do
    name = 'user'
    start = WaitForBusiness.new(name)
    assert_equal 'speech', start.speech
  end

  test 'WaitForBusiness Endpoint' do
    name = 'user'
    start = WaitForBusiness.new(name)
    assert_equal 'speech', start.speech
  end

end
