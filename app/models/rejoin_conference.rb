class RejoinConference

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

    def numdigits
    	2
    end
end