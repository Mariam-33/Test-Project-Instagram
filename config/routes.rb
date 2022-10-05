# frozen_string_literal: true

# App routes
Rails.application.routes.draw do
  root 'home#home'
  devise_for :users

  namespace :api do
    namespace :v1 do
      resources :stories, only: %i[index show]
      resources :relationships, only: [:index]
    end
  end

  resources :users do
    member do
      get :show
    end
    resources :relationships, only: %i[create index]
    resources :stories, only: [:index]
    resources :posts, only: [:index]
  end
  resources :relationships, only: %i[update destroy]
  get 'search', to: 'users#index'
  resources :posts do
    resources :photos, only: [:create]
    resources :likes, only: %i[create destroy], shallow: true
    resources :comments, only: %i[create edit update destroy]
  end
  resources :stories do
    resources :photos, only: [:create]
  end
  get '*path', to: redirect('/404')
end
