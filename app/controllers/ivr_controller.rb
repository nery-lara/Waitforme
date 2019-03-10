class IvrController < ApplicationController

  skip_before_action :verify_authenticity_token

  def verify_agent
    ivr_verify_agent = IvrVerifyAgent.new(params['Caller'])
    response = IvrResponse.new(ivr_verify_agent)
    render xml: response.xml
  end

  def welcome
    ivr_welcome = IvrWelcome.new
    response = IvrResponse.new(ivr_welcome)
    render xml: response.xml
  end

  def main_menu
    ivr_main_menu = IvrMainMenu.new
    response = IvrResponse.new(ivr_main_menu)
    render xml: response.xml
  end

  def options
    ivr_options = IvrOptions.new(params['Digits'])
    response = IvrResponse.new(ivr_options)
    render xml: response.xml
  end

end
