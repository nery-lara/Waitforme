class RejoinConference

	def initialize(user_endpoint)
		@user_endpoint = user_endpoint
	end

	def redirect
		'/calls/check_wait_or_exit/' + @user_endpoint
	end

	def hangupOnStar
		'true'
	end

  def action
  	'/calls/confirm_wait/' + @user_endpoint 
  end

	def request_method
		'POST'
	end

	def numdigits
		2
	end

end
