class Answered

	def initialize
		@msg = 'you answered the call'
		@hangupOnStar = 'true'
		@wait_for_business = '/calls/wait_for_business'
	end

	attr_reader :msg, :hangupOnStar, :wait_for_business
end
