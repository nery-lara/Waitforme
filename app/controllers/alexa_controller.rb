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
        #make a call
        account_sid = 'ACXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        auth_token = 'your_auth_token'
        @client = Twilio::REST::Client.new(account_sid, auth_token)
        call = @client.calls.create(
          url: 'http://demo.twilio.com/docs/voice.xml',
          to: twilio_number,
          from: user_number
        )
      end
    end
  end
end
