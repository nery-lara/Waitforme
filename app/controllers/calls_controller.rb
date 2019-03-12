class CallsController < ApplicationController
  include ApplicationHelper
  skip_before_action :verify_authenticity_token

  Rails.logger = Logger.new(STDOUT)

  def start
    store_url('http://wfm-env.bpdfssu2jg.us-east-2.elasticbeanstalk.com')
    store_twilio_number('+17073666816')
    session = create_user
    logger.debug 'user endpoint is ' + session.user.name
    session.user.number = params['From']
    logger.debug 'session number' + session.user.number
    session.user.sid = params['CallSid']
    logger.debug 'user callsid ' + session.user.sid
    start_conference = StartConference.new(session.user.name)
    response = VoiceResponse.new(start_conference, session)
    store_session(session.user.name, session)
    render xml: response.xml
  end


  def dial
    boot_twilio
    logger.debug 'user params' + params['user']
    session = fetch_session(params[:user])
    session.business.number = params['Digits']
    if session.business.number == '+15086875082'
      store_ivr_session(session)
    end
    logger.debug 'dial name' + session.user.name
    client = fetch_client
    call = client.calls.create(
      url: fetch_url + "/calls/answered" + '/' + session.user.name,
      to: session.business.number,
      from: session.user.number)
    forward_call = ForwardCall.new(session.business.number, session.user.name)
    response = VoiceResponse.new(forward_call, session)
    store_session(session.user.name, session)
    render xml: response.xml
  end

  def dial_business(input)
    session = create_user
    boot_twilio
    client = fetch_client
    session.business.number = input
    client.calls.create(
            url: fetch_url + "/calls/wait_for_business/" + session.user.name,
            to: session.business.number, from: fetch_twilio_number)
    session.user.number = "+18055709761"
    store_session(session.user.name, session)
  end

  def answered
    session = fetch_session(params[:user])
    session.business.sid = params['CallSid']
    logger.debug 'business callsid ' + session.business.sid
    answered_msg = Answered.new(session.user.name)
    response = VoiceResponse.new(answered_msg, session)
    store_session(session.user.name, session)
    render xml: response.xml
  end

  def conference
    session = fetch_session(params[:user])
    client = fetch_client
    event = params["StatusCallbackEvent"]
    if event == "participant-leave" and params['CallSid'] == session.user.sid
      logger.debug 'conference sid: ' + session.conference.sid
      logger.debug 'user left conference'
    end

    if event == "participant-leave" and params['CallSid'] == session.business.sid
      logger.debug 'end the whole thing, the business hung up'
      hangup_user(session)
    end

    if event == "participant-join"
      logger.debug 'someone is joining the conference'
      if params["CallSid"] == session.user.sid
        logger.debug 'user is joining the conference'
        logger.debug 'their callsid is ' + params['CallSid']
        session.conference.sid = params['ConferenceSid']
        logger.debug 'conference Sid is:' + session.conference.sid
        user = client.conferences(session.conference.sid).fetch
        logger.debug 'Conference name is: ' + user.friendly_name
        #announce = client.conferences(session.conference.sid).participants(session.user.sid).update(announce_url: fetch_url + "/calls/connect" + '/' + session.user.name)
      end
      if params["CallSid"] == session.business.sid
        logger.debug 'business is joining the conference'
        logger.debug 'their callsid is ' + params['CallSid']
      end
    end
    store_session(session.user.name, session)
  end

  def wait_for_me(user)
    client = fetch_client
    session = fetch_session(user)
    client.conferences(session.conference.sid).update(status: 'completed')
  end

  def call_user_back
    session = fetch_session(params[:user])
    client = fetch_client
    call = client.calls.create(
      url: fetch_url + "/calls/rejoin_conference/" + session.user.name,
      from: session.business.number,
      to: session.user.number
    )
    store_session(session.user.name, session)

  end

  def connect
    session = fetch_session(params[:user])
    announce = Announcement.new
    response = VoiceResponse.new(announce, session)
    render xml: response.xml
  end

  def confirm_wait
    session = fetch_session(params[:user])
    input = params['Digits']
    confirm_wait = ConfirmWait.new(input, session.user.name)
    response = VoiceResponse.new(confirm_wait, session)
    render xml: response.xml
  end

  def hangup
    response = Twilio::TwiML::VoiceResponse.new do |response|
      response.hangup
    end
    wait_for_me(params[:user])
    render xml: response.to_s
  end

  def rejoin_conference
    session = fetch_session(params[:user])
    session.user.sid = params['CallSid']
    rejoin_conference = RejoinConference.new(session.user.name)
    response = VoiceResponse.new(rejoin_conference, session)
    store_session(session.user.name, session)
    render xml: response.xml
  end

  def check_wait_or_exit
    session = fetch_session(params[:user])
    if params['CallStatus'] == 'completed'
      logger.debug 'user call completed, hang up business'
      hangup_business(sesson.user.name)
    else
      logger.debug 'user call not completed'
      response = Twilio::TwiML::VoiceResponse.new do |response|
        response.gather(action: '/calls/confirm_wait'+ '/' + session.user.name, method: 'POST', timeout: 1, numdigits: 2)
        response.redirect('/calls/rejoin_conference' + '/' + session.user.name)
      end
      render xml: response.to_s
    end
  end

  def hangup_business(user)
    session = fetch_session(user)
    client = fetch_client
    client.calls(session.business.sid).update(status: 'completed')
  end

  def hangup_user(session)
    client = fetch_client
    client.calls(session.user.sid).update(status: 'completed')
  end

  def wait_for_business
    session = fetch_session(params[:user])
    wait_for_business = WaitForBusiness.new( session.user.name)
    response = VoiceResponse.new(wait_for_business, session)
    render xml: response.xml
  end

  def business_rejoin_conference
    session = fetch_session(params[:user])
    business_rejoin_conference = BusinessRejoinConference.new
    response = VoiceResponse.new(business_rejoin_conference, session)
    call_user_back
    render xml: response.xml
  end

  def status_change
    #status changes only for user, not the business
    callsid = params['CallSid']
    status = params['CallStatus']
    logger.debug 'call status changed'
    logger.debug 'call sid:' + callsid
    if status == 'completed'
      logger.debug 'user status is complete'
    end
  end

  private
  def boot_twilio
    account_sid = 'AC14a0fc7958eb5a457b937744ac590ac4'
    auth_token = '1ac75e253415d780d1a29466adfaee02'
    client = Twilio::REST::Client.new(account_sid, auth_token)
    store_client(client)
  end

end
