# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :set_current_user
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def record_not_found(exception)
    render json: ErrorSerializer.new(exception, 404).serializable_hash, status: :not_found # 404
  end


  def set_current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
