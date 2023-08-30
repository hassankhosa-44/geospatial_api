Rails.application.routes.draw do
  root 'home#index'

  resources :tickets, only: [:show, :index]
  resources :excavators, only: [:show, :index]

  post '/api/sync', to: 'api/geospatial#create'
end
