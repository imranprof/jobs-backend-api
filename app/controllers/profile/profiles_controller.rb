module Profile
  class ProfilesController < ApplicationController
    def show
      @user = current_user
      render :show, status: :ok
    end

    def update
      if current_user.update(profile_params)
        current_user.reload
        show
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    private

    def profile_params
      params.require(:user).permit(:first_name, :last_name, :email, :phone, :password,
                                   user_profile_attributes: [:id, :headline, :title, :bio, :identity_number, :gender,
                                                             :religion, :designation, :contact_info, :contact_email,
                                                             :expertises, :avatar,
                                                             { social_link_attributes:
                                                                 %i[id facebook_url github_url linkedin_url _destroy] }],
                                   features_attributes: %i[id title description _destroy],
                                   users_skills_attributes: %i[id skill_id rating _destroy],
                                   projects_attributes: [:id, :title, :description, :live_url, :source_url,
                                                         :react_count, :image, :_destroy,
                                                         { categorizations_attributes: %i[id _destroy category_id] }],
                                   blogs_attributes: [:id, :title, :body, :reading_time, :image, :_destroy,
                                                      { categorizations_attributes: %i[id category_id _destroy] }],
                                   education_histories_attributes: %i[id institution degree grade description _destroy
                                                                      start_date end_date currently_enrolled visibility],
                                   work_histories_attributes: %i[id title employment_type company_name description _destroy
                                                                 start_date end_date currently_employed visibility])
    end
  end
end
