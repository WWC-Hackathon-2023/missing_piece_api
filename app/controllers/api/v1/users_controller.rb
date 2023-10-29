class Api::V1::UsersController < ApplicationController
  before_action :find_user, only: [:show, :dashboard]

  def show
    render json: UserSerializer.new(@user)
  end

  def dashboard
    dashboard = @user.find_dashboard_info
    render json: DashboardSerializer.new(dashboard)
  end

  def create
    new_user = User.new(user_params)
    new_user.email.downcase
    new_user.format_phone_number
    return unless new_user.save

    session[:user_id] = new_user.id
    render json: UserSerializer.new(new_user), status: :created
  end

  private

  def user_params
    params.permit(:full_name, :password, :password_confirmation, :email, :zip_code, :phone_number)
  end

  def find_user
    @user = User.find(params[:user_id])
  end
end
