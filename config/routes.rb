Rails.application.routes.draw do

  namespace :api do

    namespace :v1 do
      resources :foods, only: [:index, :show]
      resources :shifts, only: [:index, :create, :update, :show]
      resources :sessions, only: [:create, :destroy]
      resources :payment_methods, only: [:update, :show]

      resources :users, only: [:update] do
        resources :promos, only: [:create]
      end

      resources :orders, only: [:create, :index, :update, :show]
      resources :delivery_places, only: [:update]
      resources :places, only: [:index, :show]
      resources :invites, only: [:create]

      get 'users/me' => 'users#me'
      get 'couriers/me' => 'couriers#me'
      get 'places/:place_id/orders' => 'orders#index'
    end

  end

  namespace :dashboard do
    get 'partials/foods'
  end

  post 'twilio/sms' => "twilio#sms"
  root to: 'dashboard#index'
end
