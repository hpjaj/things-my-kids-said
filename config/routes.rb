Rails.application.routes.draw do

  devise_for :users

  root 'welcome#index'

  resources :posts, path: 'quotes', except: :index

  resources :kids do
    resources :posts, only: :index, path: 'quotes'
  end

end
