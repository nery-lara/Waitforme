require 'test_helper'

class VoiceResponseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test 'voice response accepts BeginCall object' do
    call = BeginCall.new
    response = VoiceResponse.new(call)
  end 
  
  test 'voice response accpets ForwardCall object' do
    call = ForwardCall.new
    response = VoiceResponse.new(call)
  end 
  
  test 'voice response throws exception for different object' do
    class DummyCall
    end 
    call = DummyCall.new
    assert_raise RuntimeError do VoiceResponse.new(call) end
  end 
  
  test 'voice response renders to xml' do
    
  end
  
end
