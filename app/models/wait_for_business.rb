class WaitForBusiness

  def initialize(user_endpoint)
    @user_endpoint = user_endpoint
    @business_rejoin_conference = '/calls/business_rejoin_conference' + '/' + user_endpoint
    @post = 'POST'
    @speech = 'speech'
    @wait_for_business = '/calls/wait_for_business'
    @speech_timeout = 1

  end

  attr_reader :business_rejoin_conference, :post, :speech, :wait_for_business, :speech_timeout

end
