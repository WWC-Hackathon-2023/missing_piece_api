# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :set_current_user
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from NoPuzzlesFoundException, with: :no_puzzles_found
  rescue_from PuzzleNotAvailableException, with: :puzzle_not_available
  rescue_from NoLoanUpdateException, with: :no_loan_update
  rescue_from InvalidAuthenticationException, with: :invalid_authentication
  rescue_from MissingAuthenticationException, with: :missing_authentication
  rescue_from UnauthorizedException, with: :unauthorized


  def set_current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def record_not_found(exception)
    render json: ErrorSerializer.new(exception, 404).serializable_hash, status: :not_found # 404
  end

  def no_puzzles_found
    error = NoPuzzlesFoundException.new("No puzzles found in this area.")
    render json: ErrorSerializer.new(error, 404).serializable_hash, status: :not_found # 404
  end

  def puzzle_not_available
    error = PuzzleNotAvailableException.new("Puzzle is not available for loan.")
    render json: ErrorSerializer.new(error, 404).serializable_hash, status: :not_found # 404
  end

  def no_loan_update
    error = NoLoanUpdateException.new("Unable to update loan.")
    render json: ErrorSerializer.new(error, 404).serializable_hash, status: :not_found # 404
  end

  def invalid_authentication
    error = InvalidAuthenticationException.new("Invalid email or password.")
    render json: ErrorSerializer.new(error, 401).serializable_hash, status: :unauthorized # 401
  end

  def missing_authentication
    error = MissingAuthenticationException.new("Email and password are required.")
    render json: ErrorSerializer.new(error, 401).serializable_hash, status: :unauthorized # 401
  end

  def unauthorized
    error = UnauthorizedException.new("Not Authorized.")
    render json: ErrorSerializer.new(error, 401).serializable_hash, status: :unauthorized # 401
  end

end

# Note to self: Saving this to remember process that lead me to final version:
# def no_puzzles
#   render status: :no_content, json: {} # 204
#   render json: { error: "No puzzles found in this area." }, status: :not_found # 404
# end