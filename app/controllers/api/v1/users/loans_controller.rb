class Api::V1::Users::LoansController < ApplicationController
  before_action :find_users_and_puzzle, only: [:create]
  before_action :check_puzzle_status, only: [:create]

  def create
    loan = Loan.new(owner_id: @owner.id, puzzle_id: @puzzle.id, borrower_id: @borrower.id)
    
    if loan.save
      render json: LoanSerializer.new(loan), status: :created #201
    else
      render json: { error: "Unable to create loan" }, status: :unprocessable_entity #422
    end
  end

  private
  def find_users_and_puzzle
    @owner = User.find(params[:user_id])
    @borrower = User.find(params[:borrower_id])
    @puzzle = Puzzle.find(params[:puzzle_id])
  end

  def check_puzzle_status
      render json: { error: "Puzzle is not available for loan." }, status: :unprocessable_entity if @puzzle.status != "Available"
  end
end
