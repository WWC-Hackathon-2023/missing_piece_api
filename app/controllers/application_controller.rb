# frozen_string_literal: true
require 'passageidentity'
require 'net/http'

class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def record_not_found(exception)
    render json: ErrorSerializer.new(exception, 404).serializable_hash, status: :not_found # 404
  end

  # Prevent CSRF attacks by raising an exception.
  protect_from_forgery with: :null_session
  
  PassageClient = Passage::Client.new(app_id: Rails.application.config.passage_app_id, api_key: Rails.application.config.passage_api_key)

  def authorize!
    begin
      @user_id = PassageClient.auth.authenticate_request(request)
    rescue Exception => e
      redirect_to "/unauthorized"
    end
  end

end

