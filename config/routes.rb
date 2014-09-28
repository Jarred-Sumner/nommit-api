Rails.application.routes.draw do
  resources :foods, only: [:index, :show]
  resources :food_delivery_places
  resources :places, only: [:index, :show]
  resources :sessions, only: [:create, :destroy]
  resources :payment_methods, only: [:update, :show]
  resources :users, only: [:update]
  resources :orders

  get 'users/me' => 'users#me'
  get 'couriers/me' => 'couriers#me'
end
