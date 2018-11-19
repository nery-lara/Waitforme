class ForwardCall < ApplicationRecord
    
    def initialize(number)
        @number = number
    end 
    
    def message
        'Forwarding your call now.'
    end 
    
    def number
        @number
    end 
end
