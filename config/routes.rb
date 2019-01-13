Rails.application.routes.draw do
  post 'calls/startconference'
  post 'calls/dial'
  post 'calls/answered'
  post 'calls/conference'
  post 'calls/waitforme'
  post 'calls/confirmwait'
  post 'calls/rejoinconference'
  post 'calls/hangup'

end
