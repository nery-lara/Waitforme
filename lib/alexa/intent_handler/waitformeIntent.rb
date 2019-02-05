module Alexa
  module IntentHandlers
    class WaitForMeIntent < Alexa::IntentHandlers::Base
      def handle
        ...
        response # intent handlers should always return the +response+ object
      end
    end
  end
end
