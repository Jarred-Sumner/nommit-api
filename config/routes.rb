Rails.application.routes.draw do
  resources :foods, only: [:index, :show]
  resources :food_delivery_places, only: :index  do
    resources :orders, only: [:update, :index]
  end
  resources :places, only: [:index, :show]
  resources :sessions, only: [:create, :destroy]
  resources :payment_methods, only: [:update, :show]
  resources :users, only: [:update]
  resources :orders

  get 'users/me' => 'users#me'
  get 'seller/food_delivery_places' => "seller/food_delivery_places#index"
end
