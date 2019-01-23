class CallsController < ApplicationController
  skip_before_action :verify_authenticity_token
  @@user_number = "8055709761"
  @@has_called = "false"
  @@user_callSid = ""
  @@business_callSid = ""

  def startconference
    puts 'inside startconference'
    @@user_number = params['From']
    @@user_callSid = params['CallSid']
    puts 'user callsid ' + @@user_callSid
    start_conference = StartConference.new
    response = VoiceResponse.new(start_conference)
    render xml: response.xml
  end

  def dial
    boot_twilio
    @@dial_number = params['Digits']
    @call = @@client.calls.create(
      url: "https://8ac58911.ngrok.io/calls/answered",
      to: @@dial_number,
      from: @@user_number)
    forward_call = ForwardCall.new(@@dial_number)
    response = VoiceResponse.new(forward_call)
    render xml: response.xml
  end

  def answered
    @@business_callSid = params['CallSid']
    puts 'business callsid ' + @@business_callSid
    answered_msg = Answered.new
    response = VoiceResponse.new(answered_msg)
    render xml: response.xml
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
    end
  end

  def waitforme
    #detect when off hold
    #call user back
    call = @@client.calls.create(
      url: "https://8ac58911.ngrok.io/calls/rejoinconference",
      from: @@dial_number,
      to: @@user_number)
    #join conference
  end

  def announcement
    announce = Announcement.new
    response = VoiceResponse.new(announce)
    response.xml
  end

  def confirmwait
    input = params['Digits']
    confirm_wait = ConfirmWait.new(input)
    response = VoiceResponse.new(confirm_wait)
    render xml: response.xml
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
    rejoin_conference = RejoinConference.new
    response = VoiceResponse.new(rejoin_conference)
    redner xml: response.xml
  end


  private
  def boot_twilio
    #account_sid = ENV["TWILIO_SID"]
    account_sid = 'ACa308c4ef25ced1bcfdd16b2ab39b4c98'
    #auth_token = ENV["TWILIO_AUTH"]
    auth_token = 'cd88c7606f8b35b059b0ad50ace29b10'
    @@client = Twilio::REST::Client.new(account_sid, auth_token)
  end
end


#user calls
#ask for number to call
#create call from
