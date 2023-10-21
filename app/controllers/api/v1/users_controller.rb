class Api::V1::UsersController < ApplicationController
  
   def create
     user = User.new(user_params)

     if user.save
      render json: UserSerializer.new(user)
     else
      render json: { error: "No user found" }
    end
  end

  def show
    render json: UserSerializer.new(User.find(params[:user_id]))
  end

  def dashboard
    user = User.find(params[:user_id])
    render json: UserSerializer.new(user, params: { action: 'dashboard' })
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :email, :zip_code, :phone_number, :user_image_url)
  end
end
