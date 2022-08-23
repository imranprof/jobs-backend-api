# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users
  post :sign_in, to: 'authentication#sign_in'
  delete :sign_out, to: 'authentication#sign_out'

  namespace :api do
    namespace :v1p1 do
      resources :dashboard, only: [:index]
      namespace :profiles do
        get '', to: 'profiles#index'
        patch ':profile_slug', to: 'profiles#update'
        post 'contact', to: 'profiles#create_contact'
        get 'search', to: 'profiles#search'
        get ':profile_slug', to: 'profiles#show'
      end

      resources :jobs, only: %i[index create] do
        collection do
          get 'job', to: 'jobs#show'
          patch 'job', to: 'jobs#update'
          delete 'job', to: 'jobs#destroy'
        end
      end
    end
  end
end
