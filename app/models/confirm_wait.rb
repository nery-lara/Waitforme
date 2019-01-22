class ConfirmWait < ApplicationRecord
	attr_reader :input

	def initialize(input)
		@input = input
	end

	def message3
		'We will call you back when a business agent is on the line'
	end

	def endpoint1
		'/calls/hangup'
	end

	def request
		'POST'
	end

	def endpoint2
		'/calls/rejoinconference'
	end
end
