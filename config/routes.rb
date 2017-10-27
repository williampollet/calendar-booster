Rails.application.routes.draw do
  get 'oauth2/redirect', to: 'oauth2#redirect', as: 'redirect'
  get 'oauth2/callback', to: 'oauth2#callback', as: 'callback'

  resources :subscriptions
  resources :notifications
  
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "subscriptions#index"
end
