class VoiceResponse
    def initialize(call)
        @call = call
        @con_call = ConferenceCall.new

        case @call
        when StartConference
            @response = Twilio::TwiML::VoiceResponse.new do |response|
                response.say(message: @call.message)
                response.gather(numDigits: @call.numdigits,
                                action: @call.endpoint,
                                method: @call.request_method)
            end

        when ForwardCall
            @response = Twilio::TwiML::VoiceResponse.new do |response|
                response.say(message: @call.message_1)
                response.say(message: @call.message_2)
                response.dial(hangupOnStar: @call.hangupOnStar) do |dial_business|
                   dial_business.conference('conference', muted:@con_call.muted, beep:@con_call.beep,
                                       statusCallbackEvent:@con_call.statusCallbackEvent,
                                       statusCallback:@con_call.statusCallback,
                                       statusCallbackMethod:@con_call.statusCallbackMethod)
                 end
                   response.gather(action: @call.action, method: @call.request_method, numdigits: @call.numdigits)
                   response.redirect('/calls/check_wait_or_exit')
                end

        when ConfirmWait
            @response = Twilio::TwiML::VoiceResponse.new do |response|
                if @call.input == '00'
                    response.say(message: @call.message3)
                    response.redirect(@call.endpoint1, method:@call.request)
                else
                    response.redirect(@call.endpoint2, method:@call.request)
                end
            end

        when Answered
           @response = Twilio::TwiML::VoiceResponse.new do |response|
              response.say(message: @call.msg)
              response.dial(hangupOnStar: @call.hangupOnStar) do |dial_back|
                 dial_back.conference('conference', muted:@con_call.muted, beep:@con_call.beep,
                                      statusCallbackEvent:@con_call.statusCallbackEvent,
                                      statusCallback:@con_call.statusCallback,
                                      statusCallbackMethod:@con_call.statusCallbackMethod)
              end
            end

        when Announcement
           @response = Twilio::TwiML::VoiceResponse.new do |response|
              response.say(message: @call.msg)
            end

        when RejoinConference
            @response = Twilio::TwiML::VoiceResponse.new do |response|
                response.dial(hangupOnStar: @call.hangupOnStar) do |redirect|
                    redirect.conference('conference', muted:@con_call.muted, beep:@con_call.beep,
                                        statusCallbackEvent:@con_call.statusCallbackEvent,
                                        statusCallback:@con_call.statusCallback,
                                        statusCallbackMethod:@con_call.statusCallbackMethod)
                  end
                response.gather(action: @call.action, method: @call.request_method, numdigits: @call.numdigits)
                response.redirect(@call.redirect)
            end
        else
            raise 'Invalid Call Type'
        end
    end

    def xml
        @response.to_s
    end
end
