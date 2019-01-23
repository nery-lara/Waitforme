class ForwardCall
    attr_reader :number

    def initialize(number)
        @number = number
    end 
    
    def message_1
        'Forwarding your call now to' + number
    end

    def message_2
    	'If you would like us to wait for you. Please press star 0 0'
    end

    def hangupOnStar
    	'true'
    end

    def action
    	'/calls/confirmwait'
    end

    def request_method
    	'POST'
    end

    def numdights
    	2
    end

    
end