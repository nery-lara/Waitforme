class ConferenceCall

	def muted
		'False'
	end

	def beep
		'False'
	end

	def statusCallbackEvent
		'join leave'
	end

	def statusCallback
		'/calls/conference'
	end

	def statusCallbackMethod
		'POST'
	end

end
