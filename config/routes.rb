Rails.application.routes.draw do

  devise_for :users

  root 'welcome#index'

  get 'home' => 'welcome#home'

  resources :posts, path: 'quotes', except: :index

  resources :kids do
    resources :posts, only: :index, path: 'quotes'
  end

end
