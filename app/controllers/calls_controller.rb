class CallsController < ApplicationController
  skip_before_action :verify_authenticity_token
  @@user_number = ""
  @@user_callSid = ""
  @@business_callSid = ""
  @@conference_Sid = ""
  @@wait_for_me = false
  @@url = 'http://27831803.ngrok.io'
  Rails.logger = Logger.new(STDOUT)

  def start
    logger.debug 'inside start'
    @@user_number = params['From']
    @@user_callSid = params['CallSid']
    logger.debug 'user callsid ' + @@user_callSid
    response = Twilio::TwiML::VoiceResponse.new do |response|
      response.say(message: 'Please enter the number you wish to call')
      response.gather(numDigits: 10,
                    action: '/calls/dial',
                    method: 'POST')
    end
    render xml: response.to_s
  end

  def dial
    boot_twilio
    @@dial_number = params['Digits']
    @call = @@client.calls.create(
      url: @@url + "/calls/answered",
      to: @@dial_number,
      from: @@user_number
    )
    response = Twilio::TwiML::VoiceResponse.new do |response|
      response.say(message: 'Forwarding your call now to' + @@dial_number)
      response.say(message: 'If you would like us to wait for you. Please press star 0 0')
      response.dial(hangupOnStar: 'true') do |d|
        d.conference('conference', muted:'False', beep:'False', statusCallbackEvent: 'join leave', statusCallback: '/calls/conference', statusCallbackMethod: 'POST')
        end
        response.redirect('/calls/check_wait_or_exit')
    end
    render xml: response.to_s
  end

  def answered
    @@business_callSid = params['CallSid']
    logger.debug 'business callsid ' + @@business_callSid
    response = Twilio::TwiML::VoiceResponse.new do |response|
      response.say(message: 'you answered the call')
      response.dial do |d|
        d.conference('conference', muted:'False', beep:'False', statusCallbackEvent: 'join leave', statusCallback: '/calls/conference', statusCallbackMethod: 'POST')
        end
    end
    render xml: response.to_s
  end

  def conference
    event = params["StatusCallbackEvent"]
    if event == "participant-leave" and params['CallSid'] == @@user_callSid
      logger.debug 'conference sid: ' + @@conference_Sid
      logger.debug 'user left conference'
    end

    if event == "participant-leave" and params['CallSid'] == @@business_callSid
      logger.debug 'business left conference'
      hangup_user
    end

    if event == "participant-join"
      logger.debug 'someone is joining the conference'
      if params["CallSid"] == @@user_callSid
        logger.debug 'user is joining the conference'
        logger.debug 'their callsid is ' + params['CallSid']
        @@conference_Sid = params['ConferenceSid']
        logger.debug 'conference Sid is:' + @@conference_Sid
        user = @@client.conferences(@@conference_Sid).fetch
        logger.debug 'here' + user.friendly_name
        announce = @@client.conferences(@@conference_Sid).participants(@@user_callSid).update(announce_url: @@url + "/calls/connect")
      end
      if params["CallSid"] == @@business_callSid
        logger.debug 'business is joining the conference'
        logger.debug 'their callsid is ' + params['CallSid']
      end
    end
  end

  def wait_for_me
    #detect when off hold
    #call user back
    call = @@client.calls.create(
      url: @@url + "/calls/rejoin_conference",
      from: @@dial_number,
      to: @@user_number
    )
    #join conference
  end

  def connect
    response = Twilio::TwiML::VoiceResponse.new do |response|
        response.say(message: 'We are connecting you with the business')
    end
    render xml: response.to_s
  end

  def confirm_wait
    user_input = params['Digits']
    response = Twilio::TwiML::VoiceResponse.new do |response|
      if user_input == '00'
        @@wait_for_me = true
        response.say(message: 'We will call you back when a business agent is on the line')
        response.redirect('/calls/hangup', method: 'POST')
      else
        response.redirect('/calls/rejoin_conference', method: 'POST')
      end
    end
    render xml: response.to_s
  end

  def hangup
    response = Twilio::TwiML::VoiceResponse.new do |response|
        response.hangup
    end
    wait_for_me
    render xml: response.to_s
  end

  def rejoin_conference
    @@user_callSid = params['CallSid']
    response = Twilio::TwiML::VoiceResponse.new do |response|
      response.dial(hangupOnStar: 'true') do |d|
        d.conference('conference', muted: 'False', beep:'False', statusCallbackEvent: 'join leave', statusCallback: '/calls/conference', statusCallbackMethod: 'POST')
        end
      response.redirect('/calls/check_wait_or_exit')
    end
    render xml: response.to_s
  end

  def check_wait_or_exit
    #call = @@client.calls(@@user_callSid).fetch
    if params['CallStatus'] == 'completed'
      logger.debug 'user call completed, hang up business'
        hangup_business
    else
      logger.debug 'user call not completed'
      response = Twilio::TwiML::VoiceResponse.new do |response|
        response.gather(action: '/calls/confirm_wait', method: 'POST', numdigits: 2)
        response.redirect('/calls/rejoin_conference')
      end
      render xml: response.to_s
    end
  end

  def hangup_business
    @@client.calls(@@business_callSid).update(status: 'completed')
  end

  def hangup_user
    @@client.calls(@@user_callSid).update(status: 'completed')
  end

  def status_change
    #status changes only for user, not the business
    callsid = params['CallSid']
    status = params['CallStatus']
    logger.debug 'call status changed'
    logger.debug 'call sid:' + callsid
    if callsid == @@user_callSid
      logger.debug 'user status changed'
      if status == 'completed'
        logger.debug 'user status is complete'
      end
    end
  end

  private
  def boot_twilio
    account_sid = ''
    auth_token = ''
  	@@client = Twilio::REST::Client.new(account_sid, auth_token)
  end
end
