class IntentHandlersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    input = AlexaRubykit.build_request(params)
    output = AlexaRubykit::Response.new
    session_end = true
    message = "There was an error."

    case input.type
    when "LAUNCH_REQUEST" #this case might not be used
      message = "Say something"
    when "INTENT_REQUEST"
      case input.name
      when "UserInput"
        response = input.slots["businessType"].value
        message = "You said, #{response}"
        start(response)
      end
    end
  end

  def start(business_number)
    twilio_number = ''
    call = @client.calls.create(
      url:@url + "alexa/call_user",
      to:business_number,
      from:twilio_number
    )
    # forward_call = ForwardCall.new(business_number)
    # response = VoiceResponse.new(forward_call)
    # render xml: response.xml
  end

  def answered
    @@business_callSid = params['CallSid']
    logger.debug 'business callsid ' + @@business_callSid
    answered_msg = Answered.new
    response = VoiceResponse.new(answered_msg)
    render xml: response.xml
  end

  def call_user
    call = @client.calls.create(
      url:@url + "calls/answered",
      to:phone_number,
      from:twilio_number # another twilio number?
    )
    # forward_call = ForwardCall.new(phone_number)
    # response = VoiceResponse.new(forward_call)
    # render xml: response.xml
  end


  private
  def boot_twilio
    account_sid = ''
    auth_token = ''
    @url = ''
    @client = Twilio::REST::Client.new(account_sid, auth_token)
  end
end
