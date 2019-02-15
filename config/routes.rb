Rails.application.routes.draw do

  post 'calls/start'
  post 'calls/dial'
  post 'calls/answered'
  post 'calls/conference'
  post 'calls/wait_for_me'
  post 'calls/confirm_wait'
  post 'calls/rejoin_conference'
  post 'calls/hangup'
  post 'calls/connect'
  post 'calls/status_change'
  post 'calls/check_wait_or_exit'
  post 'calls/wait_for_me'
  post 'calls/wait_for_business'
  post 'calls/business_rejoin_conference'
  post 'ivr/welcome'
  post 'ivr/main_menu'
  post 'ivr/options'
  post 'ivr/call_business_rep'

end
