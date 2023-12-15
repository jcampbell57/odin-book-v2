Rails.application.routes.draw do
  # get 'friendships/create'
  # get 'likes/create'
  # get 'comments/new'
  # get 'comments/create'
  # get 'posts/index'
  # get 'posts/show'
  # get 'posts/new'
  # get 'posts/create'
  # get 'users/index'
  # get 'users/show'

  root 'posts#index'

  devise_for :users

  resources :users, only: %i[index show] do
    resources :friendships, only: %i[create] do
      collection do
        get 'accept_friend'
        get 'decline_friend'
      end
    end
  end

  put '/users/:id', to: 'users#update_img'

  resources :posts, only: %i[index new create show destroy] do
    resources :likes, only: %i[create]
  end

  resources :comments, only: %i[new create destroy] do
    resources :likes, only: %i[create]
  end
end
