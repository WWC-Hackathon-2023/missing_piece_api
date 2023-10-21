# frozen_string_literal: true

class UserSerializer
  include JSONAPI::Serializer
  attributes :full_name,
             :email,
             :zip_code,
             :phone_number,
             :user_image_url

  attributes :owner_loans, if: proc { |record, params|
    if params[:action] == 'dashboard'
      owner_loans = record.owner_loans.includes(:puzzle) # eager loading puzzles
      # loans = record.owner_loans

      owner_loans.map do |loan|      
        puzzle = loan.puzzle
        { 
          # owner_loan: LoanSerializer.new(loan), 
          loan_id: loan.id,
          owner_id: loan.owner_id,
          borrower_id: loan.borrower_id,
          loan_status: loan.status,
          loan_created_at: loan.created_at,
          puzzle_id: loan.puzzle_id,
          puzzle_image: puzzle.puzzle_image_url,
          puzzle_title: puzzle.title,
          puzzle_status: puzzle.status
          # loan_puzzle_info: PuzzleSerializer.new(puzzle)
        }
      end
    end
  }

  attributes :borrower_loans, if: proc { |record, params|
    if params[:action] == 'dashboard'
      borrower_loans = record.borrower_loans.includes(:puzzle) # eager loading puzzles

      borrower_loans.map do |loan|      
        puzzle = loan.puzzle
        { 
          # borrower_loan: LoanSerializer.new(loan), 
          loan_id: loan.id,
          owner_id: loan.owner_id,
          borrower_id: loan.borrower_id,
          loan_status: loan.status,
          loan_created_at: loan.created_at,
          puzzle_id: loan.puzzle_id,
          puzzle_image: puzzle.puzzle_image_url,
          puzzle_title: puzzle.title,
          puzzle_status: puzzle.status
          # loan_puzzle_info: PuzzleSerializer.new(puzzle)
        }
      end
    end
  }

end