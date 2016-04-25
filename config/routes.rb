Rails.application.routes.draw do

  devise_for :users

  root 'welcome#index'

  resources :posts

  resources :kids, only: [:index, :new, :create]
end
