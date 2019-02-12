class StartConference

	def initialize(user_endpoint)
		@user_endpoint = user_endpoint
	end

	def message
		'Please enter the number you wish to call'
	end

	def endpoint
		'/calls/dial/' + @user_endpoint
	end

	def request_method
		'POST'
	end

	def numdigits
		10
	end
end
