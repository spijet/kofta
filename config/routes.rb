Rails.application.routes.draw do
  resources :datatypes
  resources :devices
  post 'snmpquerier/getinfo'

  get 'ui/index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'ui#index'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
