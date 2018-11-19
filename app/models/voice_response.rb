class VoiceResponse < ApplicationRecord
    
    def initialize(call)
        @call = call
        case @call
        when BeginCall then @response = Twilio::TwiML::VoiceResponse.new do |r| 
            r.say(message: @call.message)
            r.gather(numDigits: @call.numDigits,
            action: @call.endpoint,
            method: @call.method)
            end
        when ForwardCall then @response = Twilio::TwiML::VoiceResponse.new do |r|
            r.say(message: @call.message)
            r.dial(number: @call.number)
            end
        else raise 'Invalid Call Type'
        end
    end
    
    def xml 
        render xml: @response.to_s
    end
    
end
