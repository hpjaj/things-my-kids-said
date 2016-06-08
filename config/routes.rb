Rails.application.routes.draw do

  devise_for :users
  get 'users/sign_out' => "devise/sessions#destroy"

  root 'welcome#index'

  get 'home' => 'welcome#home'

  resources :posts, path: 'quotes', except: :index do
    member do
      get 'display_comments'
    end
  end

  resources :friend_and_families, path: 'friends_and_family'

  resources :parents, only: [:index, :new, :create, :destroy]

  resources :kids do
    resources :posts, only: :index, path: 'quotes'
  end

  resources :posts, only: :show, path: 'quotes' do
    resources :comments, only: [:new, :create, :destroy]
  end

end
