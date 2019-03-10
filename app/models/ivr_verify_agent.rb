class IvrVerifyAgent

  def initialize(number)
    @call_from = number
    @business_agent = '+18056405991'
    @agent_join_conference = '/ivr/agent_join_conference'
    @welcome = '/ivr/welcome'
  end

  attr_reader :call_from, :business_agent, :agent_join_conference, :welcome
end
