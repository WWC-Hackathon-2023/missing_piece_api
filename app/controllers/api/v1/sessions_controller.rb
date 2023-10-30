class Api::V1::SessionsController < ApplicationController
  skip_before_action :set_current_user, only: [:create]
  before_action :authorize, only: [:destroy]

  def create
    authenticate_user
    session[:user_id] = @returning_user.id
    render json: UserSerializer.new(@returning_user), status: :created
  end

  def destroy
    session.delete(:user_id)
    head :no_content
  end

  private
  
  def authorize
    raise UnauthorizedException if params[:user_id].to_i != session[:user_id]
  end

  def authenticate_user
    if params[:email].present? && params[:password].present?
      @returning_user = User.find_by(email: params[:email])
      raise InvalidAuthenticationException unless @returning_user&.authenticate(params[:password])
    else 
      raise MissingAuthenticationException
    end
  end
end