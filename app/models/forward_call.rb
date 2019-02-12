class ForwardCall
    attr_reader :number

    def initialize(number, user_endpoint)
        @number = number
        @user_endpoint = user_endpoint
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
    	'/calls/confirm_wait/' + @user_endpoint
    end

    def request_method
    	'POST'
    end

    def numdigits
    	2
    end


end
