class RejoinConference < ApplicationRecord

	def redirect
		'/calls/rejoinconference'
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