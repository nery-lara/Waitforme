class CallsController < ApplicationController
  skip_before_action :verify_authenticity_token
  #skip_before_filter :authenticate_user!, :only => "reply"	

  def begin
  	customer_number = params["From"]
  	twilio_number = ENV["TWILIO_NUMBER"]
  	boot_twilio
  	
  	response = Twilio::TwiML::VoiceResponse.new do |r|
      r.say(message: 'Please enter the number you wish to call')
      r.gather(numDigits: 10,
                    action: '/calls/dial',
                    method: 'POST')
    end
    render xml: response.to_s
  end
    
  def dial
    dial_number = params['Digits']
    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.say(message: 'Forwarding your call now.')
      r.dial(number: dial_number)
    end
    render xml: response.to_s
  end

  private
  def boot_twilio
  	account_sid = ENV["TWILIO_SID"]
  	auth_token = ENV["TWILIO_AUTH"]
  	@client = Twilio::REST::Client.new account_sid, auth_token
  end
end
