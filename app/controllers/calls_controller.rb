class CallsController < ApplicationController
  skip_before_action :verify_authenticity_token
  @@user_number = ""
  @@has_called = "false"
  @@user_callSid = ""
  @@business_callSid = ""
  def startconference
    puts 'inside startconference'
    @@user_number = params['From']
    @@user_callSid = params['CallSid']
    puts 'user callsid ' + @@user_callSid
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
    @call = @@client.calls.create(
      url: "http://c0ae5a76.ngrok.io/calls/answered",
      to: @@dial_number,
      from: @@user_number
    )
    #user = @@client.conferences('conference').participants(@@user_callSid).create(from: @@user_number, to: @@dial_number)
    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.say(message: 'Forwarding your call now to' + @@dial_number)
      r.say(message: 'If you would like us to wait for you. Please press star 0 0')
      r.dial(hangupOnStar: 'true') do |d|
        d.conference('conference', muted:'False', beep:'False',statusCallbackEvent:'join leave', statusCallback:'/calls/conference',
          statusCallbackMethod:'POST')
        end
      r.gather(action: '/calls/confirmwait', method: 'POST', numdigits: 2)
      r.redirect('/calls/rejoinconference')
    end
    render xml: response.to_s
  end

  def answered
    @@business_callSid = params['CallSid']
    puts 'business callsid ' + @@business_callSid
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
    if @event == "participant-leave" and @@has_called == "false" and params['CallSid'] == @@user_callSid
      conference = @@client.conferences("conference").update(status: 'completed')
      @@has_called = 'true'
    end

    if @event == "participant-leave" and params['CallSid'] == @@business_callSid
      puts 'end the whole thing, the business hung up'
      conference = @@client.conferences("conference").update(status: 'completed')
    end

    if @event == "participant-join"
      puts 'someone is joining the conference'
      if params["CallSid"] == @@user_callSid
        puts 'user is joining the conference'
        puts 'there callsid is ' + params['CallSid']
      end
      #user = @@client.conferences('conference').participants(@@user_callSid).update(announce_url: "http://c0ae5a76.ngrok.io/calls/announcement")
    end
    #render xml: response.to_s
  end

  def waitforme
    #detect when off hold
    #call user back
    call = @@client.calls.create(
      url: "http://c0ae5a76.ngrok.io/calls/rejoinconference",
      from: @@dial_number,
      to: @@user_number
    )
    #join conference
  end

  def announcement
    response = Twilio::TwiML::VoiceResponse.new do |r|
        r.say(message: 'This is an announcement')
    end
    render xml: response.to_s
  end


  def confirmwait
    input = params['Digits']
    response = Twilio::TwiML::VoiceResponse.new do |r|
      if input == '00'
        r.say(message: 'We will call you back when a business agent is on the line')
        r.redirect('/calls/hangup', method: 'POST')

      else
        r.redirect('/calls/rejoinconference', method: 'POST')
      end
    end
    render xml: response.to_s
  end

  def hangup
    response = Twilio::TwiML::VoiceResponse.new do |r|
        r.hangup
    end
    waitforme
    render xml: response.to_s
  end
  def rejoinconference
    @@user_callSid = params['CallSid']
    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.dial(hangupOnStar: 'true') do |d|
        d.conference('conference', muted:'False', beep:'False',statusCallbackEvent:'join leave', statusCallback:'/calls/conference',
          statusCallbackMethod:'POST')
        end
      r.gather(action: '/calls/confirmwait', method: 'POST', numdigits: 2)
      r.redirect('/calls/rejoinconference')
    end
    render xml: response.to_s
  end





  private
  def boot_twilio
  	#account_sid = ENV["TWILIO_SID"]
    account_sid = 'AC14a0fc7958eb5a457b937744ac590ac4'
  	#auth_token = ENV["TWILIO_AUTH"]
    auth_token = '1ac75e253415d780d1a29466adfaee02'
  	@@client = Twilio::REST::Client.new(account_sid, auth_token)
  end
end


#user calls
#ask for number to call
#create call from
