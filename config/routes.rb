Rails.application.routes.draw do
  get 'extras', to: 'extras#index'
  post 'extras/import_devices'
  post 'extras/import_metrics'
  get 'extras/export_devices'
  get 'extras/export_metrics'

  get 'stats', to: 'stats#index'
  get 'stats/gc'
  get 'stats/rufus'
  get 'stats/sidekiq'

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
