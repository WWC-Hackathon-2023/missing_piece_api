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

  def unauthorized(exception = "Not Authorized.")
    render json: ErrorSerializer.new(exception, 401).serializable_hash, status: :unauthorized # 401
  end

  private

  def no_puzzles_found
    record_not_found(NoPuzzlesFoundException.new("No puzzles found in this area."))
  end

  def puzzle_not_available
    record_not_found(PuzzleNotAvailableException.new("Puzzle is not available for loan."))
  end

  def no_loan_update
    record_not_found(NoLoanUpdateException.new("Unable to update loan."))
  end

  def invalid_authentication
    unauthorized(InvalidAuthenticationException.new("Invalid email or password."))
  end

  def missing_authentication
    unauthorized(MissingAuthenticationException.new("Email and password are required."))
  end
end

# Note to self: Saving this to remember process that lead me to final version:
# def no_puzzles
#   render status: :no_content, json: {} # 204
#   render json: { error: "No puzzles found in this area." }, status: :not_found # 404
# end
