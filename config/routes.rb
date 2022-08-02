# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users
  post :sign_in, to: 'authentication#sign_in'
  delete :sign_out, to: 'authentication#sign_out'

  namespace :api do
    namespace :v1p1 do
      resources :dashboard, only: [:index]
      namespace :profiles do
        get ':profile_slug', to: 'profiles#show'
        patch ':profile_slug', to: 'profiles#update'
        post 'contact', to: 'profiles#create_contact'
      end
    end
  end
end
