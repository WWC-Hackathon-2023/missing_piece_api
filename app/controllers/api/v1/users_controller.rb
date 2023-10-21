module Api
  module V1
    class UsersController < ApplicationController
      def show
        render json: UserSerializer.new(User.find(params[:user_id]))
      end

      def dashboard
        user = User.find(params[:user_id])
        render json: UserSerializer.new(user, params: { action: 'dashboard' })
      end
    end
  end
end
