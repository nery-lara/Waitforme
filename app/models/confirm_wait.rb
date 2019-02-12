class ConfirmWait
	attr_reader :input

	def initialize(input, user_endpoint)
		@input = input
		@user_endpoint = user_endpoint
	end

	def message3
		'We will call you back when a business agent is on the line'
	end

	def endpoint1
		'/calls/hangup/' + @user_endpoint
	end

	def request
		'POST'
	end

	def endpoint2
		'/calls/rejoin_conference/' + @user_endpoint
	end
end
