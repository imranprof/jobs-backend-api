# frozen_string_literal: true

module Api
  module V1p1
    module Profiles
      class ProfilesController < ApplicationController
        before_action :authenticate_request, only: %i[update]
        before_action :edit_permission?, only: %i[show]
        before_action :messenger_id, only: %i[create_contact]

        PAGINATION_LIMIT = 8

        def index
          @profiles = UserProfile.order(id: :asc)
                                 .limit(PAGINATION_LIMIT)
                                 .offset((profiles_params[:page].to_i || 0) * PAGINATION_LIMIT)
        end

        def search
          value = search_params[:search_value].downcase
          first_name = value
          last_name = value
          designation = value
          full_name = value.split
          space = value.match(' ')
          if space != nil
            if full_name.length == 1
              first_name = full_name[0]
              last_name = full_name[0]
            else
              first_name = full_name[0]
              last_name = full_name[1]
            end
          end

          @profiles = UserProfile.joins(:user).where('lower(users.first_name) LIKE ?', '%'+first_name+'%')
                                 .or(UserProfile.joins(:user).where('lower(users.last_name) LIKE ?', '%'+last_name+'%'))
                                 .or(UserProfile.where('lower(user_profiles.designation) LIKE ?', '%'+designation+'%'))

          render :index
        end

        def show
          @user = UserProfile.find_by(slug: params[:profile_slug])&.user
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

        def create_contact
          @user_contact = UserContact.new(contact_params)
          @user_contact.messenger_id = @messenger_id if @messenger_id
          if @user_contact.save
            render json: { message: 'Message has been sent successfully.' }, status: :created
          else
            render json: { message: 'Sorry, something wrong' }
          end
        end

        private

        def profiles_params
          params.permit(:page)
        end

        def search_params
          params.permit(:search_value)
        end

        def profile_params
          params.require(:user).permit(:first_name, :last_name, :email, :phone, :password,
                                       user_profile_attributes: user_profile_attributes,
                                       features_attributes: %i[id title description _destroy],
                                       users_skills_attributes: %i[id skill_id rating skill_title _destroy],
                                       projects_attributes: projects_attributes,
                                       blogs_attributes: blogs_attributes,
                                       education_histories_attributes: education_histories_attributes,
                                       work_histories_attributes: work_histories_attributes)
        end

        def user_profile_attributes
          [:id, :headline, :title, :bio, :identity_number, :gender,
           :religion, :designation, :contact_info, :contact_email,
           :expertises, { avatar: :data },
           { social_link_attributes:
               %i[id facebook github linkedin _destroy] }]
        end

        def projects_attributes
          [:id, :title, :description, :live_url, :source_url,
           :react_count, { image: :data }, :_destroy,
           { categorizations_attributes: %i[id _destroy category_id] }]
        end

        def blogs_attributes
          [:id, :title, :body, :reading_time, { image: :data }, :_destroy,
           { categorizations_attributes: %i[id category_id _destroy] }]
        end

        def education_histories_attributes
          %i[id institution degree grade description _destroy start_date end_date currently_enrolled visibility]
        end

        def work_histories_attributes
          %i[id title employment_type company_name description _destroy start_date end_date currently_employed visibility]
        end

        def contact_params
          params.require(:user_contact).permit(:name, :phone_number, :email, :subject, :message, :user_id, :messenger_id)
        end

        def edit_permission?
          @edit_permission = false
          user_profile_id = User.find_by(token: request.headers['Authorization'])&.user_profile&.id
          @edit_permission = user_profile_id == UserProfile.find_by(slug: params[:profile_slug])&.id if user_profile_id
        end

        def messenger_id
          @messenger_id = User.find_by(token: request.headers['Authorization'])&.id
        end
      end
    end
  end
end
