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
          post 'apply', to: 'jobs#apply'
          post 'my-jobs', to: 'jobs#my_jobs'
          patch 'employee-select', to: 'jobs#job_seeker_selection'
          patch 'hire_job_seeker', to: 'jobs#hire_job_seeker'
          patch 'accept-hire-offer', to: 'job_applications#accept_hire_offer'
          get 'search', to: 'jobs#search'
          get 'job_application/:id', to: 'jobs#job_application_show'
          get 'offers', to: 'job_applications#job_offers'
          get 'offer/:id', to: 'job_applications#show_job_offer'
          get 'best_matches', to: 'job_applications#best_matches_jobs'
        end
      end

      resources :messages, only: %i[index create] do
        collection do
          post 'send_message', to: 'messages#send_message'
          post 'show_threads', to: 'messages#show_threads'
          post 'private_conversation', to: 'messages#private_conversation'
          patch 'message', to: 'messages#update_message_status'
        end
      end
    end
  end
  mount ActionCable.server, at: '/cable'
end
