Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  namespace :api do

    namespace :v1 do
      resources :foods, only: [:index, :show]

      resources :shifts, only: [:index, :create, :update, :show] do
        resources :orders, only: [:index]
      end

      resources :sellers, only: [:create, :index, :show] do
        resources :foods, only: [:index]
      end

      resources :sessions, only: [:create, :destroy]
      resources :payment_methods, only: [:update, :show]
      resources :schools, only: [:index, :show]

      resources :users, only: [:update] do
        get 'subscription' => "subscriptions#show"
        post 'subscription' => "subscriptions#create"
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
    get 'partials/dashboard'
    get 'partials/foods'
    get 'partials/account'
    get 'partials/sell'
    get 'partials/support'
    get 'partials/places'
    get 'partials/deliver'
    get 'partials/invite'
    get 'partials/payment_method'
    get 'partials/delivery_places'
    get 'partials/schools'
    get 'partials/activate'
    get 'partials/confirm'
    get 'partials/orders/new' => 'partials#new_order'
    get 'partials/orders/show' => 'partials#show_order'
  end


  get 'foods' => 'dashboard#index'
  get 'foods/places' => 'dashboard#index'
  get 'foods/:food_id/order' => 'dashboard#index', as: :new_order

  get 'orders' => 'dashboard#index'
  
  get 'account' => 'dashboard#index'
  get 'account/payment_method' => 'dashboard#index'
  get 'account/schools' => 'dashboard#index'

  get 'sell' => "dashboard#index"

  get 'deliver' => 'dashboard#index'
  get 'deliver/places' => 'dashboard#index'
  get 'orders/:id' => 'dashboard#index'
  get 'support' => 'dashboard#index'
  get 'invite' => 'dashboard#index'
  
  get 'activate' => "dashboard#index"
  get 'activate/confirm' => "dashboard#index"
  get 'activate/payment_method' => 'dashboard#index'
  get 'activate/schools' => "dashboard#index"
  get 'login' => 'dashboard#login'


  post 'twilio/sms' => "twilio#sms"

  root to: 'dashboard#index'
  get 'dashboard' => redirect("/")

  get '/auth/facebook/callback' => 'dashboard#facebook'
  get '/auth/failure' => redirect("/login")
  get '/admin/logout' => "dashboard#logout", as: :destroy_admin_user_session
  get '/logout' => "dashboard#logout", as: :logout

  get 'download' => redirect("https://itunes.apple.com/us/app/nommit/id928890698?mt=8")

end
