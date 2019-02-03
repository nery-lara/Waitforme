class CallsController < ApplicationController
  skip_before_action :verify_authenticity_token
  @@user_number = ""
  @@has_called = ""
  @@user_callSid = ""
  @@business_callSid = ""
  @@waitforme = false
  @@url = ''
  Rails.logger = Logger.new(STDOUT)

  def start
    logger.debug 'inside start'
    @@user_number = params['From']
    @@user_callSid = params['CallSid']
    logger.debug 'user callsid ' + @@user_callSid
    start_conference = StartConference.new
    response = VoiceResponse.new(start_conference)
    render xml: response.xml
  end

  def dial
    boot_twilio
    @@dial_number = params['Digits']
    @call = @@client.calls.create(
      url: @@url + "/calls/answered",
      to: @@dial_number,
      from: @@user_number)
    forward_call = ForwardCall.new(@@dial_number)
    response = VoiceResponse.new(forward_call)
    render xml: response.xml
  end

  def answered
    @@business_callSid = params['CallSid']
    logger.debug 'business callsid ' + @@business_callSid
    answered_msg = Answered.new
    response = VoiceResponse.new(answered_msg)
    render xml: response.xml
  end

  def conference
    @event = params["StatusCallbackEvent"]
    if @event == "participant-leave" and params['CallSid'] == @@user_callSid
      logger.debug 'conference sid: ' + @@conference_Sid
      logger.debug 'user left conference'
    end

    if @event == "participant-leave" and params['CallSid'] == @@business_callSid
      logger.debug 'end the whole thing, the business hung up'
      hangup_user
    end

    if @event == "participant-join"
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
    @@client.conferences(@@conference_Sid).update(status: 'completed')

    #call user back
    call = @@client.calls.create(
      url: @@url + "/calls/rejoin_conference",
      from: @@dial_number,
      to: @@user_number
    )
    #join conference
  end

  def connect
    announce = Announcement.new
    response = VoiceResponse.new(announce)
    render xml: response.xml
  end

  def confirm_wait
    input = params['Digits']
    confirm_wait = ConfirmWait.new(input)
    response = VoiceResponse.new(confirm_wait)
    render xml: response.xml
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
    rejoin_conference = RejoinConference.new
    response = VoiceResponse.new(rejoin_conference)
    render xml: response.xml
  end

  def check_wait_or_exit
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
