class Api::V1::Users::LoansController < ApplicationController
  def create
    puzzle = Puzzle.find(params[:puzzle_id])
    borrower = User.find(params[:borrower_id])

    loan = Loan.new(owner: puzzle.user, puzzle: puzzle, borrower: borrower)

    if loan.save
      render json: LoanSerializer.new(loan), status: 201
    else
      render json: { error: "Unable to create loan" }, status: 422
    end
  end
end
