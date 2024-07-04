Rails.application.routes.draw do
  root 'posts#index'

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
  }

  # https://github.com/heartcombo/devise/wiki/OmniAuth:-Overview#logout-links
  # devise_scope :user do
  # delete 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
  # end

  resources :users, only: %i[index show notifications] do
    get :notifications, on: :member
    resources :friendships, only: %i[create destroy] do
      collection do
        get 'accept_friend'
        get 'decline_friend'
        delete 'remove_friend'
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
