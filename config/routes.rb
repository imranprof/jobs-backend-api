# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users
  post :sign_in, to: 'authentication#sign_in'
  delete :sign_out, to: 'authentication#sign_out'
  post :linkedin_login, to: 'social_auth#linkedin_auth'
  patch 'user/role', to: 'users#update_role'

  namespace :api do
    namespace :v1p1 do
      resources :dashboard, only: [:index]
      namespace :profiles do
        get '', to: 'profiles#index'
        patch ':profile_slug', to: 'profiles#update'
        post 'contact', to: 'profiles#create_contact'
        get 'search', to: 'profiles#search'
        get ':profile_slug', to: 'profiles#show'
        get 'resume/:profile_slug', to: 'profiles#resume'
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
          patch 'search', to: 'jobs#search'
          get 'job_application/:id', to: 'jobs#job_application_show'
          get 'offers', to: 'job_applications#job_offers'
          get 'offer/:id', to: 'job_applications#show_job_offer'
          get 'best_matches', to: 'jobs#best_matches_jobs'
          get 'most_recent', to: 'jobs#most_recent_jobs'
        end
      end

      resources :job_applications do
        collection do
          post 'job_contracts', to: 'job_applications#show_job_contracts'
          patch 'end_contract', to: 'job_applications#job_contract_end'
          patch 'feedback', to: 'job_applications#give_feedback_and_rating'
          get 'job_contract/:id', to: 'job_applications#show_contract'
        end
      end

      resources :job_contracts do
        collection do
          post 'time_sheet', to: 'job_contracts#add_working_details'
          patch 'time_sheet', to: 'job_contracts#update_working_details'
          delete 'time_sheet', to: 'job_contracts#destroy_time_sheet'
          get 'time_sheets', to: 'job_contracts#show_time_sheets'
          post 'time_sheets', to: 'job_contracts#send_timesheet_to_employer'
          patch 'time_sheets', to: 'job_contracts#approved_rejected_weekly_timesheet'
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
