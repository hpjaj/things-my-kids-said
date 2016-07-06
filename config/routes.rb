Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  get 'users/sign_out' => "devise/sessions#destroy"

  root 'welcome#index'

  get 'home' => 'welcome#home'
  get 'about' => 'welcome#about'
  get 'help' => 'welcome#help'

  resources :posts, path: 'quotes', except: :index do
    member do
      get 'display_comments'
    end
  end

  post 'select_picture' => 'posts#select_picture'

  resources :friend_and_families, path: 'friends_and_family'

  resources :parents, only: [:index, :new, :create, :destroy]

  resources :kids do
    resources :posts, only: :index, path: 'quotes'
  end

  resources :posts, only: :show, path: 'quotes' do
    resources :comments, except: [:index, :show]
  end

  get 'my_kids_quotes' => 'quote_exports#my_kids'

end
