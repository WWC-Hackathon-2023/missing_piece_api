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


  #DRAFT ONE: 

  # There are two ways to write this syntax for Proc
  # OPTION 1: the value of xxxx_loans is an array of hashes
  # attributes :owner_loans, if: proc { |record, params|
  #   LoanSerializer.new(record.owner_loans) if params[:action] == 'dashboard'
  # }

  # attributes :borrower_loans, if: proc { |record, params|
  #   LoanSerializer.new(record.borrower_loans) if params[:action] == 'dashboard'
  # }

  # OPTION 2: the value of xxxx_loans is a hash with key of data that is an array of hashes
  # attributes :owner_loans, if: Proc.new { |record, params| params[:action] == 'dashboard' } do |object, params|
  #   LoanSerializer.new(object.owner_loans)
  # end

  # attributes :borrower_loans, if: Proc.new { |record, params| params[:action] == 'dashboard' } do |object, params|
  #   LoanSerializer.new(object.borrower_loans)
  # end

  # NOTE: on Proc.new
  # We are providing a block of code that returns true or false based on the condition params[:action] == "dashboard."
  # The Proc acts as a callable object that the serializer can use to determine whether the attribute should be included
  # or not. So, the Proc.new is used to properly encapsulate the conditional logic and return a boolean value, allowing
  # the serializer to determine whether to include the :borrower_loans attribute based on the value of params[:action].
