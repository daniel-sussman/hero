Rails.application.routes.draw do
  devise_for :users
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
  root "activities#index"
  get "up" => "rails/health#show", as: :rails_health_check
end
