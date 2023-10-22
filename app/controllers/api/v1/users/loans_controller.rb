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

  def update
    user = User.find(params[:id])
    loan = Loan.find(params[:loan_id])

    if params[:action_type] == 'deny' || params[:action_type] == 'withdraw'
      if loan.update(status: 2)
        render json: LoanSerializer.new(loan), status: 200
      else
        render json: { error: "Unable to update loan status" }, status: 422
      end
    elsif params[:action_type] == 'invalid_action'
      render json: { error: "Invalid action" }, status: 422
    else
      render json: { error: "Unable to update loan status" }, status: 422
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
