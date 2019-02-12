Rails.application.routes.draw do
  post 'calls/start'
  post 'calls/dial/:user', to: 'calls#dial'
  post 'calls/answered/:user', to: 'calls#answered'
  post 'calls/conference/:user', to: 'calls#conference'
  post 'calls/wait_for_me/:user', to: 'calls#wait_for_me'
  post 'calls/confirm_wait/:user', to: 'calls#confirm_wait'
  post 'calls/rejoin_conference/:user', to: 'calls#rejoin_conference'
  post 'calls/hangup/:user', to: 'calls#hangup'
  post 'calls/connect/:user', to: 'calls#connect'
  post 'calls/status_change'
  post 'calls/check_wait_or_exit/:user', to: 'calls#check_wait_or_exit'

end
