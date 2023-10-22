class Api::V1::UsersController < ApplicationController
  def show
    render json: UserSerializer.new(User.find(params[:user_id]))
  end

  # def dashboard
  #   dashboard = User.find(params[:user_id]).find_dashboard_info
  #   render json: DashboardSerializer.new(dashboard)
  # end

  def dashboard
    if authenticate_user 
      dashboard = User.find(params[:user_id]).find_dashboard_info
      render json: DashboardSerializer.new(dashboard)
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  private

  def authenticate_user
    begin
      user_id = PassageClient.auth.authenticate_request(request)
      return user_id.present?
    rescue Exception => e
      return false
    end
  end

end
