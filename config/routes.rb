Rails.application.routes.draw do
  devise_for :users
  resources :activities, only: [:index, :show] do
    member do
      patch :like
      patch :save
      patch :click
    end
  end
  resources :categories, only: [:index, :show]
  resources :encounters, only: [:create, :update]
  resources :users, only: [:show]
  resources :collections
  root "activities#index"
  get "up" => "rails/health#show", as: :rails_health_check
end
