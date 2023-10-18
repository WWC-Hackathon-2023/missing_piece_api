class Api::V1::UsersController < ApplicationController

  def show
    user = User.find(params[:id])
    render json: UsersSerializer.new(user)
  end
end

