Rails.application.routes.draw do
  get 'friendships/create'
  get 'likes/create'
  get 'comments/new'
  get 'comments/create'
  root 'posts#index'

  get 'posts/index'
  get 'posts/show'
  get 'posts/new'
  get 'posts/create'
  get 'users/index'
  get 'users/show'

  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
