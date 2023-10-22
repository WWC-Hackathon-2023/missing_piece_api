class Api::V1::SessionsController < ApplicationController
  skip_before_action :set_current_user, only: [:create]
  before_action :authorize, only: [:destroy]

  def create
    if params[:email].present? && params[:password].present?
      returning_user = User.find_by(email: params[:email])

      # the & is called a "safe navigation" operator
      # It prevent a "NoMethodError" from being raised when invoking a method on nil
      if returning_user&.authenticate(params[:password])
        session[:user_id] = returning_user.id
        render json: UserSerializer.new(returning_user), status: :created
      else
        render json: { error: 'Invalid email or password' }, status: :unauthorized
      end
    else
      render json: { error: 'Email and password are required' }, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    head :no_content
  end

  private

  def authorize
    render json: { error: 'Not authorized' }, status: :unauthorized unless session[:user_id]
  end
end
