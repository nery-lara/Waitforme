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

end
