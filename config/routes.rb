Rails.application.routes.draw do
  resources :activities, only: [:index, :show]
  resources :categories, only: [:index, :show]
  resources :encounters, only: [:create, :update] do
    member do
      get :like
      get :save
    end
  end
  resources :users, only: [:show]
  resources :collections
  devise_for :users
  root "activities#index"
  get "up" => "rails/health#show", as: :rails_health_check
end
