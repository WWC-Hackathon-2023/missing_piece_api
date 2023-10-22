class Api::V1::Users::LoansController < ApplicationController
  def create
    puzzle = Puzzle.find(params[:puzzle_id])
    borrower = User.find(params[:borrower_id])

    loan = Loan.new(owner: puzzle.user, puzzle:, borrower:)

    if loan.save
      render json: LoanSerializer.new(loan), status: 201
    else
      render json: { error: "Unable to create loan" }, status: 422
    end
  end

  def update
    user = User.find(params[:id])
    loans = Loan.where(owner_id: user.id).or(Loan.where(borrower_id: user.id))
    loan_id = loans.find(params[:loan_id])

    if params[:action_type] == 'deny' || params[:action_type] == 'withdraw'
      if loan_id.update(status: 2)
        dashboard_info = user.find_dashboard_info
        render json: LoanSerializer.new(loan_id), status: 200
      else
        render json: { error: "Unable to update loan status" }, status: 422
      end
    elsif params[:action_type] == 'invalid_action'
      render json: { error: "Invalid action" }, status: 422
    else
      render json: { error: "Unable to update loan status" }, status: 422
    end
  end
end
