# frozen_string_literal: true

module Api
  module V1p1
    module Profiles
      class ProfilesController < ApplicationController
        before_action :authenticate_request, only: %i[update]
        before_action :edit_permission?, only: %i[show]
        before_action :messenger_id, only: %i[create_contact]
        include ActionController::MimeResponds

        def index
          @profiles = UserProfile.joins(:user).where('users.role != ?', 'employer')
                                 .order(id: :asc)
                                 .limit(UserProfile::PAGINATION_LIMIT)
                                 .offset((profiles_params[:page].to_i || 0) * UserProfile::PAGINATION_LIMIT)
        end

        def search
          value = search_params[:search_value].downcase
          first_name = last_name = designation = skill_title = value
          full_name = value.split
          space = value.match(' ')
          unless space.nil?
            if full_name.length == 1
              first_name = last_name = full_name[0]
            else
              first_name = full_name[0]
              last_name = full_name[1]
            end
          end

          @profiles = UserProfile.joins(:user).where('(lower(users.first_name) LIKE ?
                                                       OR lower(users.last_name) LIKE ?
                                                       OR lower(user_profiles.designation) LIKE ?)
                                                       AND users.role != ?', "%#{first_name}%", "%#{last_name}%", "%#{designation}%", 'employer')

          profiles_by_skill = UserProfile.joins({ user: { skills: :users_skills } }).where('lower(skills.title)  LIKE ?', "%#{skill_title}%")
          @profiles = (@profiles + profiles_by_skill).uniq

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

        def resume
          @user = UserProfile.find_by(slug: params[:profile_slug])&.user
          @profile = @user&.user_profile
          @skills = @user&.skills
          @education_histories = @user&.education_histories
          @work_histories = @user&.work_histories
          @contact = @user&.user_contacts
          @social_links = @profile&.social_link
          @avatar = url_for(@user&.user_profile.avatar)

          respond_to do |format|
            format.html
            format.pdf do
              html = render_to_string(template: 'resume/resume')
              pdf = WickedPdf.new.pdf_from_string(html)
              send_data pdf, filename: "#{params[:profile_slug]}.pdf"
            end
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
           :location, :designation, :contact_info, :contact_email, :hourly_rate,
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
