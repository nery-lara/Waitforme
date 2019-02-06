class StartConference
	attr_reader :number

	def initializer(input)
		@number = input

	def message
		'Please enter the number you wish to call'
	end

	def endpoint
		'/calls/dial'
	end

	def request_method
		'POST'
	end

<<<<<<< HEAD
	# def numdigits
	# 	10
	# end
=======
	def numdigits
		10
	end

>>>>>>> 8b786608a195d3524594a35eb47fdfc11d1b9a93
end
