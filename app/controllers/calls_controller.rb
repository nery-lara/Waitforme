class CallsController < ApplicationController
  skip_before_action :verify_authenticity_token
  @@host_number = ""
  @@has_called = "false"
  def startconference
    @@host_number = params['From']
    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.say(message: 'Please enter the number you wish to call')
      r.gather(numDigits: 10,
                    action: '/calls/dial',
                    method: 'POST')
    end
    render xml: response.to_s
  end

  def dial
    boot_twilio
    @@dial_number = params['Digits']
    @call = @client.calls.create(
      url: "http://8c8f6a57.ngrok.io/calls/answered",
      to: @@dial_number,
      from: @@host_number
    )
    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.say(message: 'Forwarding your call now to' + @@dial_number)
      r.dial do |d|
        d.conference('conference', muted:'False', beep:'False',statusCallbackEvent:'join leave', statusCallback:'/calls/conference',
          statusCallbackMethod:'POST')
        end
    end
    render xml: response.to_s
  end

  def answered
    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.say(message: 'you answered the call')
      r.dial do |d|
        d.conference('conference', muted:'False', beep:'False',statusCallbackEvent:'join leave', statusCallback:'/calls/conference',
          statusCallbackMethod:'POST')
        end
    end
    render xml: response.to_s
  end

  def conference
    @event = params["StatusCallbackEvent"]
    boot_twilio
    if @event == "participant-leave" and @@has_called == "false"

      call = @client.calls.create(
        url: "http://8c8f6a57.ngrok.io/calls/waitforme",
        from: @@dial_number,
        to: @@host_number
      )
      @@has_called = 'true'
      #user hung up
      #call back user to simulate waiting in hold
      # response = Twilio::TwiML::VoiceResponse.new do |r|
      #   r.say(message: 'will call user back after 10 sec')
      #   r.pause(length: 10)
      #   r.dial(number: @@host_number) do |d|
      #     d.conference('conference')
      #   end
      # end
    end
    #render xml: response.to_s
  end

  def waitforme
    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.say(message: 'We are connecting you with the business')
      r.dial do |d|
        d.conference('conference', muted:'False', beep:'False',statusCallbackEvent:'join leave', statusCallback:'/calls/conference',
          statusCallbackMethod:'POST')
        end
    end
    render xml: response.to_s
  end

  private
  def boot_twilio
  	#account_sid = ENV["TWILIO_SID"]
    account_sid = 'AC14a0fc7958eb5a457b937744ac590ac4'
  	#auth_token = ENV["TWILIO_AUTH"]
    auth_token = '1ac75e253415d780d1a29466adfaee02'
  	@client = Twilio::REST::Client.new account_sid, auth_token
  end
end


#user calls
#ask for number to call
#create call from
