class StartConference
	attr_reader :number


	def message
		'Please enter the number you wish to call'
	end

	def endpoint
		'/calls/dial'
	end

	def request_method
		'POST'
	end

	def numdigits
		10
	end
end
