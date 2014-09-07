Rails.application.routes.draw do
  resources :foods, only: [:index, :show]
  resources :sessions, only: [:create, :destroy]
  resources :users, only: [:create]
  resources :orders
end
