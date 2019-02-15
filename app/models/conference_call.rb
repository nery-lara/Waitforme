class ConferenceCall

	def initialize(session)
		@session = session
	end

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
  	'/calls/conference/' + @session.user.name
  end

  def statusCallbackMethod
  	'POST'
  end

	def conf_name
		#session.conference.name
		'conference'
	end
end
