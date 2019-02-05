module Alexa
  module IntentHandlers
    class Base
      class << self
        def inherited(subclass)
          subclass.instance_variable_set("@_required_slot_names", _required_slot_names.clone)
        end

        # Lets you set +required_slot_names+ per subclass
        #
        # class IntentHandlers::NewIntent < IntentHandlers::Base
        #   required_slot_names :Function, :CareerLevel
        # end
        #
        # handler = IntentHandlers::NewIntent.new
        # handler.required_slot_names   # => [:Function, :CareerLevel]

        def _required_slot_names
          @_required_slot_names ||= []
        end

        def required_slot_names(*names)
          @_required_slot_names = names.map(&:to_s)
        end
      end

    end
  end
end
