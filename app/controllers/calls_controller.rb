class CallsController < ApplicationController
  skip_before_action :verify_authenticity_token
  #skip_before_filter :authenticate_user!, :only => "reply"	
  
  def begin
  	boot_twilio
  	beginCall = BeginCall()
  	response = VoiceResponse(beginCall)
    response.xml()
  end
    
  def dial
    forwardCall = ForwardCall(params['Digits'])
    response = VoiceResponse(forwardCall)
    response.xml()
  end

  private
  def boot_twilio
  	account_sid = ENV["TWILIO_SID"]
  	auth_token = ENV["TWILIO_AUTH"]
  	@client = Twilio::REST::Client.new account_sid, auth_token
  end
  
end 
