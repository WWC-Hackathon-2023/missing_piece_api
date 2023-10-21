class Api::V1::Users::LoansController < ApplicationController
    def create
        puzzle = Puzzle.find(params[:puzzle_id])
        borrower = User.find(params[:borrower_id])

        loan = Loan.new(owner: puzzle.user, puzzle: puzzle, borrower: borrower)

        if loan.save
            render json: { loan: loan, message: "Loan created successfully" }, status: :created
        else
            render json: { error: "Unable to create loan" }, status: :unprocessable_entity
        end
    end
end