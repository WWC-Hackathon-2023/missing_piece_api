class Api::V1::UsersController < ApplicationController

  def show
    render json: UserSerializer.new(User.find(params[:user_id]))
  end
end

