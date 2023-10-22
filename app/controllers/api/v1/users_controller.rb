class Api::V1::UsersController < ApplicationController

  def show
    render json: UserSerializer.new(User.find(params[:user_id]))
  end

  def dashboard
    dashboard = User.find(params[:user_id]).find_dashboard_info
    render json: DashboardSerializer.new(dashboard)
  end

  def create
    new_user = User.new(user_params)
    new_user.format_phone_number
    if new_user.save
      session[:user_id] = new_user.id
      render json: UserSerializer.new(new_user), status: :created
    end
  end

  private
  def user_params
    params.permit(:full_name, :password, :password_confirmation, :email, :zip_code, :phone_number) 
  end
end
