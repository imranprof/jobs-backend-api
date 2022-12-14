# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]
  before_action :authenticate_request, only: %i[show update destroy update_role]

  def index
    @users = User.all
    render json: @users
  end

  def show
    render json: @user
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render :'api/v1p1/profiles/profiles/show', status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: @user, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      render json: { message: 'User deleted successfully' }, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update_role
    profile = UserProfile.find_by(id: update_role_params[:profile_id])
    @user = profile&.user
    if @user&.modify_role == false
      render json: { message: 'you are not authorize for update role' }, status: :unauthorized
    else
      is_modify = update_role_params[:modify_role]
      render json: @user&.errors, status: :unprocessable_entity and return if is_modify.nil?

      if is_modify && @user&.update_columns(modify_role: false, role: 'employer')
        head :ok
      elsif @user&.update_columns(modify_role: false)
        head :ok
      else
        render json: @user&.errors, status: :unprocessable_entity
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :role, :company_name)
  end

  def update_role_params
    params.require(:user).permit(:profile_id, :modify_role)
  end

end
