# frozen_string_literal: true

module Api
  module V1p1
    module Profiles
      class ProfilesController < ApplicationController
        before_action :authenticate_request, only: %i[update]

        def show
          @user = User.find_by(id: params[:user_id])
          render json: { error: 'User is not found' }, status: :not_found unless @user
        end

        def update
          if current_user.update(profile_params)
            current_user.reload
            @user = current_user
            render :show, status: :ok
          else
            render json: current_user.errors, status: :unprocessable_entity
          end
        end

        private

        def profile_params
          params.require(:user).permit(:first_name, :last_name, :email, :phone, :password,
                                       user_profile_attributes: user_profile_attributes,
                                       features_attributes: %i[id title description _destroy],
                                       users_skills_attributes: %i[id skill_id rating _destroy],
                                       projects_attributes: projects_attributes,
                                       blogs_attributes: blogs_attributes,
                                       education_histories_attributes: education_histories_attributes,
                                       work_histories_attributes: work_histories_attributes)
        end

        def user_profile_attributes
          [:id, :headline, :title, :bio, :identity_number, :gender,
           :religion, :designation, :contact_info, :contact_email,
           :expertises, :avatar,
           { social_link_attributes:
               %i[id facebook_url github_url linkedin_url _destroy] }
          ]
        end

        def projects_attributes
          [:id, :title, :description, :live_url, :source_url,
           :react_count, :image, :_destroy,
           { categorizations_attributes: %i[id _destroy category_id] }
          ]
        end

        def blogs_attributes
          [:id, :title, :body, :reading_time, :image, :_destroy,
           { categorizations_attributes: %i[id category_id _destroy] }
          ]
        end

        def education_histories_attributes
          %i[id institution degree grade description _destroy start_date end_date currently_enrolled visibility]
        end

        def work_histories_attributes
          %i[id title employment_type company_name description _destroy start_date end_date currently_employed visibility]
        end

      end
    end
  end
end
