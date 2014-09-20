Rails.application.routes.draw do
  resources :foods, only: [:index, :show]
  resources :sessions, only: [:create, :destroy]
  resources :users, only: [:create]
  resources :payment_methods, only: [:update, :show]
  resources :orders
end
