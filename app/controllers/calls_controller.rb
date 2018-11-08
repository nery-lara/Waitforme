class CallsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate_user!, :only => "reply"	

  def reply
  	customer_number = params["From"]
  	twilio_number = ENV["TWILIO_NUMBER"]
  	boot_twilio
  	
  	response = Twilio::TwiML::VoiceResponse.new
  	response.dial(number: '805-640-5991')
  	response.say(message: 'Call failed')
  	puts response
  end

  private
  def boot_twilio
  	account_sid = ENV["TWILIO_SID"]
  	auth_token = ENV["TWILIO_AUTH"]
  	@client = Twilio:REST::Client.new account_sid, auth_token
end
