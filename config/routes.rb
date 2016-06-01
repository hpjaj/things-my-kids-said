Rails.application.routes.draw do

  devise_for :users
  get 'users/sign_out' => "devise/sessions#destroy"

  root 'welcome#index'

  get 'home' => 'welcome#home'

  resources :posts, path: 'quotes', except: :index

  resources :friend_and_families

  resources :parents, only: [:index, :new, :create, :destroy]

  resources :kids do
    resources :posts, only: :index, path: 'quotes'
  end

end
