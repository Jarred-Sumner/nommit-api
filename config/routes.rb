Rails.application.routes.draw do

  namespace :api do

    namespace :v1 do
      resources :foods, only: [:index, :show]
      resources :shifts, only: [:index, :create, :update, :show] do
        resources :orders, only: [:index]
      end
      resources :sessions, only: [:create, :destroy]
      resources :payment_methods, only: [:update, :show]

      resources :users, only: [:update] do
        resources :promos, only: [:create]
      end
      resources :devices, only: [:create]
      resources :promos, only: [:show]

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
    get 'partials/account'
    get 'partials/fundraise'
    get 'partials/support'
    get 'partials/places'
    get 'partials/deliver'
    get 'partials/invite'

    get 'partials/orders/new' => 'partials#new_order'
    get 'partials/orders/show' => 'partials#show_order'
  end

  post 'twilio/sms' => "twilio#sms"

  get 'foods' => 'dashboard#index'
  get 'orders' => 'dashboard#index'
  get 'account' => 'dashboard#index'
  get 'fundraise' => "dashboard#index"
  get 'places' => 'dashboard#index'
  get 'deliver' => 'dashboard#index'
  get 'order' => 'dashboard#index'
  get 'order/:id' => 'dashboard#index'
  get 'support' => 'dashboard#index'
  get 'invite' => 'dashboard#index'

  root to: 'dashboard#index'

  get 'download' => redirect("https://itunes.apple.com/us/app/nommit/id928890698?mt=8")
end
