module Api
  module V1
    class UsersController < ApplicationController
      def show
        render json: UserSerializer.new(User.find(params[:user_id]))
      end

<<<<<<< HEAD
      def dashboard
        user = User.find(params[:user_id])
        render json: UserSerializer.new(user, params: { action: 'dashboard' })
      end
    end
=======
  def dashboard
    dashboard = User.find(params[:user_id]).find_dashboard_info
    render json: DashboardSerializer.new(dashboard)
>>>>>>> 434c0354a110cda0a8db3935c807108c6e2c7276
  end
end
