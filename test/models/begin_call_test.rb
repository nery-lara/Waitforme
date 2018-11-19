require 'test_helper'

class BeginCallTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test 'begin call is post method' do
    call = BeginCall.new
    assert('POST', call.method())
  end
  
  test 'begin call message ask for number' do
    msg = 'Please enter the number you wish to call'
    call = BeginCall.new
    assert(msg, call.message())
  end 
  
  test 'begin call asks for correct num of digits' do
    call = BeginCall.new
    assert(10, call.numDigits())
  end 
  
  test 'begin call sends to /calls/dial' do
    call = BeginCall.new
    endpoint = '/calls/dial'
    assert(endpoint, call.endpoint())
  end 
end
