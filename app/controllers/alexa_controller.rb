class AlexaController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create # change name
    input = AlexaRubykit.build_request(params)
    output = AlexaRubykit::Response.new
    session_end = true
    message = "There was an error."

    case input.type
    when "LAUNCH_REQUEST" #this case might not be used
      message = "Say something"
    when "INTENT_REQUEST"
      business_name = input.slots['friend']['value']
      puts business_name
      call_business(business_name)
      message = "calling #{business_name} now"
      # start(response)
    when "SESSION_ENDED_REQUEST"
      # it's over
      message = nil
    end

    output.add_speech(message) unless message.blank?
    render json: output.build_response(session_end)
  end

  # def start(business_number)
  #   twilio_number = ''
  #   call = @client.calls.create(
  #     url:@url + "alexa/call_user",
  #     to:business_number,
  #     from:twilio_number
  #   )
  #   # forward_call = ForwardCall.new(business_number)
  #   # response = VoiceResponse.new(forward_call)
  #   # render xml: response.xml
  # end
  #
  # def answered
  #   @@business_callSid = params['CallSid']
  #   logger.debug 'business callsid ' + @@business_callSid
  #   answered_msg = Answered.new
  #   response = VoiceResponse.new(answered_msg)
  #   render xml: response.xml
  # end
  #
  # def call_user
  #   call = @client.calls.create(
  #     url:@url + "calls/answered",
  #     to:phone_number,
  #     from:twilio_number # another twilio number?
  #   )
  #   # forward_call = ForwardCall.new(phone_number)
  #   # response = VoiceResponse.new(forward_call)
  #   # render xml: response.xml
  # end
  def call_business(business_name)
   puts "in call_business"
   case business_name
   when "Jackie"
     start("+18056405991")#phone_number
   when "angel"
     start("+15622784150")
   when "yuhao"
     start("+18052801861")
   when "sitao"
     start("+18055709761")
   when "Andrew"
     start("+15622784150")
   end
 end

  def start(phone_number)
    call_object = CallsController.new
    call_object.dial_business(phone_number)
  end

end
