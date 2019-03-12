class Answered

	def initialize(user_endpoint)
		@msg = 'you answered the call'
		@hangupOnStar = 'true'
		@wait_for_business = '/calls/wait_for_business' + '/' + user_endpoint
	end

	attr_reader :msg, :hangupOnStar, :wait_for_business

end
