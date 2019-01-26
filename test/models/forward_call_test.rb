require 'test_helper'

class ForwardCallTest < ActiveSupport::TestCase
  test 'Initialize' do
    forward = ForwardCall.new('3')
    assert_equal '3', forward.number
  end

  test 'Message_1' do
    forward = ForwardCall.new('3')
    assert_equal 'Forwarding your call now to' + forward.number, forward.message_1
  end

  test 'Message_2' do
    forward = ForwardCall.new('3')
    assert_equal 'If you would like us to wait for you. Please press star 0 0', forward.message_2
  end

  test 'HangupOnStar' do
    forward = ForwardCall.new('3')
    assert_equal 'true', forward.hangupOnStar
  end

  test 'Action' do
    forward = ForwardCall.new('3')
    assert_equal '/calls/confirm_wait', forward.action
  end

  test 'Request_method' do
    forward = ForwardCall.new('3')
    assert_equal 'POST', forward.request_method
  end

  test 'Numdigits' do
    forward = ForwardCall.new('3')
    assert_equal 2, forward.numdigits
  end
end
