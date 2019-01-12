Rails.application.routes.draw do
  post 'calls/startconference'
  post 'calls/dial'
  post 'calls/answered'
  post 'calls/conference'
  post 'calls/waitforme'
end
