Rails.application.routes.draw do

  devise_for :users

  root 'welcome#index'

  resources :posts, except: :index

  resources :kids do
    resources :posts, only: :index
  end

end
