class Api::V1::UsersController < ApplicationController

  def show
    render json: UsersSerializer.new(User.find(params[:id]))
  end
end

