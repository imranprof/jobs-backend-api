# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users
  post '/sign_in', to: 'authentication#sign_in'
  delete '/sign_out', to: 'authentication#sign_out'

  namespace :api do
    namespace :v1 do
      get '/seek_right_jobs', to: 'api#seek_right_jobs'
    end
  end
end
