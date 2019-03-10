class IvrResponse

  def initialize(call)
    @call = call
    @con_call = ConferenceCall.new

    case @call

    when IvrVerifyAgent
      if @call.call_from == @call.business_agent
        @response = Twilio::TwiML::VoiceResponse.new do |response|
          response.dial do |redirect|
            redirect.conference('conference', muted:@con_call.muted, beep:@con_call.beep)
          end
        end
      else
        @response = Twilio::TwiML::VoiceResponse.new do |response|
          response.redirect(@call.welcome)
        end
      end

    when IvrWelcome
      @response = Twilio::TwiML::VoiceResponse.new do |response|
        response.pause(length: 4)
        response.redirect(@call.ivr_main_menu)
      end

    when IvrMainMenu
      @response = Twilio::TwiML::VoiceResponse.new do |response|
        response.gather(numDigits: @call.num_digits, action: @call.ivr_options, menthod: @call.post)
        response.say(voice: 'man', message: @call.ivr_main_menu)
        response.redirect(@call.main_menu)
      end

    when IvrOptions
      if @call.user_input == @call.input1
        @response = Twilio::TwiML::VoiceResponse.new do |response|
          response.say(voice: 'man', message: @call.business_hours)
        end
      elsif @call.user_input == @call.input2
        @response = Twilio::TwiML::VoiceResponse.new do |response|
          response.say(voice: 'man', message: @call.please_wait)
          response.dial do |redirect|
            redirect.conference('conference', muted:@con_call.muted, beep:@con_call.beep)
          end
        end
      else
        @response = Twilio::TwiML::VoiceResponse.new do |response|
          response.say(voice: 'man', message: @call.return_main_menu)
          response.redirect(@call.ivr_main_menu)
        end
      end

    else
      raise 'Invalid Call Type'
    end
  end

  def xml
    @response.to_s
  end

end
