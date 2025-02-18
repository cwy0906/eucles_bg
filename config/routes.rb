
require "sidekiq/web"

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")

  
  root "backstage#index"
  get  "/login"    => "user_sessions#index"
  post '/login'    => "user_sessions#create"
	delete '/logout' => "user_sessions#destroy" 

  resources :users

  get  "/exchange_rate/:bank_name/index" => "exchange_rate#index"
  get  "/exchange_rate/:bank_name/update_jpy_chart" => "exchange_rate#update_jpy_chart"
  get  "/exchange_rate/:bank_name/update_usd_chart" => "exchange_rate#update_usd_chart"

  mount Sidekiq::Web => "/sidekiq"
end
