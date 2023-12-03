Rails.application.routes.draw do
  get 'searches/index'
  devise_for :users
  resources :activities, only: [:index, :show] do
    member do
      patch :like
      patch :save
      patch :click
      patch :attended
      patch :rating
    end
  end
  resources :categories, only: [:index, :show] do
    member do
      get :category_index
    end
  end
  resources :encounters, only: [:create, :update]
  resources :users, only: [:show]
  resources :collections do
    member do
      get :collection_index
    end
  end
  resources :searches, only: [:index]
  root "activities#index"
  get "up" => "rails/health#show", as: :rails_health_check
end
