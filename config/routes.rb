Rails.application.routes.draw do

  devise_for :users

  root 'welcome#index'

  resources :posts, only: [:index, :new, :create]
end
