class IvrController < ApplicationController

  skip_before_action :verify_authenticity_token

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

  def call_business_rep
    ivr_call_business_rep = IvrCallBusinessRep.new
    response = IvrResponse.new(ivr_call_business_rep)
    render xml: response.xml
  end

end
