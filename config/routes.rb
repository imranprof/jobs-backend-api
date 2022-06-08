# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users
  post :sign_in, to: 'authentication#sign_in'
  delete :sign_out, to: 'authentication#sign_out'

  namespace :api do
    namespace :v1p1 do
      resources :dashboard, only: [:index]
    end
  end

  namespace :api do
    namespace :v1p1 do
      namespace :profiles do
        get 'profile', to: 'profiles#show'
        patch 'profile', to: 'profiles#update'
      end
    end
  end
end
