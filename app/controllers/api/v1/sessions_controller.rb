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
    head :no_content # Ensures that the client receives an HTTP status code of 204 No Content along with an empty response body
  end

  private
  
  def authorize
    raise UnauthorizedException if params[:user_id].to_i != session[:user_id]
  end

  def authenticate_user
    check_email_password_presence
    @returning_user = User.find_by(email: params[:email])
    raise InvalidAuthenticationException unless @returning_user&.authenticate(params[:password]) # The & is a 'safe navigation operator' which allows you to call a method on an object only if that object is not nil 
  end

  def check_email_password_presence
    raise MissingAuthenticationException unless params[:email].present? && params[:password].present?
  end
end