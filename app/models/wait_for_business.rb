class WaitForBusiness

  def initialize
    @business_rejoin_conference = '/calls/business_rejoin_conference'
    @post = 'POST'
    @speech = 'speech'
    @wait_for_business = '/calls/wait_for_business'
  end

  attr_reader :business_rejoin_conference, :post, :speech, :wait_for_business

end
