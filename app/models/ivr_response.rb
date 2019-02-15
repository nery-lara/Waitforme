class IvrResponse

  def initialize(call)
    @call = call

    case @call
    when IvrWelcome
      @response = Twilio::TwiML::VoiceResponse.new do |response|
        response.say(message: @call.welcome_user)
        response.redirect(@call.ivr_main_menu)
      end

    when IvrMainMenu
      @response = Twilio::TwiML::VoiceResponse.new do |response|
        response.gather(numDigits: @call.num_digits, action: @call.ivr_options, menthod: @call.post)
        response.say(message: @call.ivr_main_menu)
        response.redirect(@call.main_menu)
      end

    when IvrOptions
      if @call.user_input == @call.input1
        @response = Twilio::TwiML::VoiceResponse.new do |response|
          response.say(message: @call.business_hours)
        end
      elsif @call.user_input == @call.input2
        @response = Twilio::TwiML::VoiceResponse.new do |response|
          response.say(message: @call.please_wait)
          response.play(loop: @call.repeat_num, url: @call.audio)
          response.redirect(@call.call_business_rep)
        end
      else
        @response = Twilio::TwiML::VoiceResponse.new do |response|
          response.say(message: @call.return_main_menu)
          response.redirect(@call.ivr_main_menu)
        end
      end

    when IvrCallBusinessRep
      @response = Twilio::TwiML::VoiceResponse.new do |response|
        response.dial(number: @call.business_number)
      end

    else
      raise 'Invalid Call Type'
    end
  end

  def xml
    @response.to_s
  end

end
