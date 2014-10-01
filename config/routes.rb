Rails.application.routes.draw do
  resources :foods, only: [:index, :show]
  resources :shifts, only: [:index, :create, :update, :show]
  resources :sessions, only: [:create, :destroy]
  resources :payment_methods, only: [:update, :show]
  resources :users, only: [:update]
  resources :orders, only: [:create, :index, :update, :show]
  resources :delivery_places, only: [:update]
  resources :places, only: :index

  get 'users/me' => 'users#me'
  get 'places/:place_id/orders' => 'orders#index'
end
