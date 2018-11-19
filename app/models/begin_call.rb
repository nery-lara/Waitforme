class BeginCall < ApplicationRecord
    
    def message
        'Please enter the number you wish to call'
    end
    
    def endpoint
        '/calls/dial'
    end
    
    def method
        'POST'
    end 
    
    def numDigits
        10
    end 
    
end
