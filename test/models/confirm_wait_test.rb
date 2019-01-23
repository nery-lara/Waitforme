require 'test_helper'

class ConfirmWaitTest < ActiveSupport::TestCase
  test 'Initialize' do
    confirm = ConfirmWait.new('3')
    assert_equal '3', confirm.input
  end

  test 'Message3' do
    confirm = ConfirmWait.new('3')
    assert_equal 'We will call you back when a business agent is on the line', confirm.message3
  end

  test 'Endpoint1' do
    confirm = ConfirmWait.new('3')
    assert_equal '/calls/hangup', confirm.endpoint1
  end

  test 'Request' do
    confirm = ConfirmWait.new('3')
    assert_equal 'POST', confirm.request
  end

  test 'Endpoint2' do
    confirm = ConfirmWait.new('3')
    assert_equal '/calls/conference', confirm.endpoint2
  end
end
