class Api::V1::Users::LoansController < ApplicationController
  before_action :find_users_and_puzzle, only: [:create]
  before_action :check_puzzle_status, only: [:create]
  before_action :find_loan, only: [:update]

  def create
    loan = Loan.new(owner_id: @owner.id, puzzle_id: @puzzle.id, borrower_id: @borrower.id)
    return unless loan.save && loan.puzzle.update(status: 1)
    render json: LoanSerializer.new(loan), status: :created # 201
  end

  def update
    updated_loan = @loan.update_status_and_puzzle_status(params[:action_type])
    render json: LoanSerializer.new(updated_loan), status: 200
  end

  private

  def find_users_and_puzzle
    @owner = User.find(params[:user_id])
    @borrower = User.find(params[:borrower_id])
    @puzzle = Puzzle.find(params[:puzzle_id])
  end

  def check_puzzle_status
    raise PuzzleNotAvailableException unless @puzzle.status == "Available"
  end

  def find_loan
    @loan = Loan.find(params[:loan_id])
  end
end
