Rails.application.routes.draw do
  root to: 'visitors#index'
  devise_for :users
  resources :users
  get 'new_transaction', to: "users#new_transaction"
  get 'total_transaction', to: "users#total_transaction"
  post 'users/user_create', to: "users#user_create"
  post 'users/create_transaction', to: "users#create_transaction"
end
