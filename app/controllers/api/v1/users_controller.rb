class Api::V1::UsersController < ApplicationController
  def show
    render json: UserSerializer.new(User.find(params[:user_id]))
  end

  def dashboard
    dashboard = User.find(params[:user_id]).find_dashboard_info
    render json: DashboardSerializer.new(dashboard)
  end
end
