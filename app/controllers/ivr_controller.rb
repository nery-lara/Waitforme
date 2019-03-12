class IvrController < ApplicationController
  include ApplicationHelper
  skip_before_action :verify_authenticity_token

  def verify_agent
    session = fetch_ivr_session
    ivr_verify_agent = IvrVerifyAgent.new(params[:Caller], session.user.name)
    response = IvrResponse.new(ivr_verify_agent)
    store_ivr_session(session)
    render xml: response.xml
  end

  def welcome
    session = fetch_ivr_session
    ivr_welcome = IvrWelcome.new(session.user.name)
    response = IvrResponse.new(ivr_welcome)
    store_ivr_session(session)
    render xml: response.xml
  end

  def main_menu
    session = fetch_ivr_session
    ivr_main_menu = IvrMainMenu.new(session.user.name)
    response = IvrResponse.new(ivr_main_menu)
    store_ivr_session(session)
    render xml: response.xml
  end

  def options
    session = fetch_ivr_session
    ivr_options = IvrOptions.new(params['Digits'], session.user.name)
    response = IvrResponse.new(ivr_options)
    store_ivr_session(session)
    render xml: response.xml
  end

end
