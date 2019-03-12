class IvrController < ApplicationController
  include ApplicationHelper
  skip_before_action :verify_authenticity_token

  def verify_agent
    session = fetch_ivr_session
    ivr_verify_agent = IvrVerifyAgent.new(session.user.number, session.user.name)
    response = IvrResponse.new(ivr_verify_agent,  session)
    store_ivr_session(session)
    render xml: response.xml
  end

  def welcome
    session = fetch_session(params[:user])
    ivr_welcome = IvrWelcome.new(session.user.name)
    response = IvrResponse.new(ivr_welcome, session)
    store_ivr_session(session)
    render xml: response.xml
  end

  def main_menu
    session = fetch_session(params[:user])
    ivr_main_menu = IvrMainMenu.new(session.user.name)
    response = IvrResponse.new(ivr_main_menu, session)
    store_ivr_session(session)
    render xml: response.xml
  end

  def options
    session = fetch_session(params[:user])
    ivr_options = IvrOptions.new(params['Digits'], session.user.name)
    response = IvrResponse.new(ivr_options, session)
    store_ivr_session(session)
    render xml: response.xml
  end

end
