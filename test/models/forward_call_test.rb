require 'test_helper'

class ForwardCallTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test 'forward call returns passed in number' do
    msg = 'Forwarding your call now.'
    number = '1234567890'
    call = ForwardCall.new(number)
    assert(msg, call.message())
  end
  
  test 'forward call has forwarding call message' do
    number = '1234567890'
    call = ForwardCall.new(number)
    assert(number, call.number())
  end 
  
end
