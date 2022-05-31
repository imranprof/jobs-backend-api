# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users
  post :sign_in, to: 'authentication#sign_in'
  delete :sign_out, to: 'authentication#sign_out'

  namespace :api do
    namespace :v1 do
      resources :dashboard, only: [:index]
    end
  end

  get 'profile', to: 'profile/profiles#show'
  patch 'profile', to: 'profile/profiles#update'
  get 'profiles', to: 'profile/profiles#index'

end
