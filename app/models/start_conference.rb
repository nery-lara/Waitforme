class StartConference

	def message
		'Please enter the number you wish to call'
	end

	def endpoint
		'/calls/dial'
	end

	def request_method
		'POST'
	end

	def num_digits
		10
	end
end