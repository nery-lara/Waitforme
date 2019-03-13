class IvrVerifyAgent

  def initialize(number, user)
    @call_from = number
    @business_agent = '+18056405991'
    #@business_agent = '+14156106787'
    @ivr_main_menu = '/ivr/main_menu' + '/' + user
  end

  attr_reader :call_from, :business_agent, :ivr_main_menu
end
