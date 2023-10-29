class Api::V1::Users::LoansController < ApplicationController
  before_action :find_users_and_puzzle, only: [:create]
  before_action :check_puzzle_status, only: [:create]
  before_action :find_loan, only: [:update]

  def create
    loan = Loan.new(owner_id: @owner.id, puzzle_id: @puzzle.id, borrower_id: @borrower.id)
    if loan.save && loan.puzzle.update(status: 1)
      render json: LoanSerializer.new(loan), status: :created #201
    end
  end

  def update
    # loan = Loan.find(params[:loan_id])

    if params[:action_type] == 'accept'
      @loan.update(status: 1)
      @loan.puzzle.update(status: 2)
      render json: LoanSerializer.new(@loan), status: 200 
    elsif params[:action_type] == 'withdraw'
      @loan.update(status: 2)
      @loan.puzzle.update(status: 0)
      render json: LoanSerializer.new(@loan), status: 200 
    elsif params[:action_type] == 'deny' 
      @loan.update(status: 2)
      @loan.puzzle.update(status: 2)
      render json: LoanSerializer.new(@loan), status: 200
    elsif params[:action_type] == 'close'
      @loan.update(status: 3)
      @loan.puzzle.update(status: 0)
      render json: LoanSerializer.new(@loan), status: 200 
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
    raise PuzzleNotAvailableException unless @puzzle.status == "Available"
  end

  def find_loan
    @loan = Loan.find(params[:loan_id])
  end
end
