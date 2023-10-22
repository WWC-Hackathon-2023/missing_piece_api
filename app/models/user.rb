require 'ostruct'

class User < ApplicationRecord
  has_many :puzzles
  has_many :owner_loans, class_name: 'Loan', foreign_key: 'owner_id'
  has_many :borrower_loans, class_name: 'Loan', foreign_key: 'borrower_id'

  validates_presence_of :full_name, :email, :zip_code, :phone_number, :password, :password_confirmation
  validates_uniqueness_of :email, :phone_number
  validates_numericality_of :zip_code

  has_secure_password

  def format_phone_number
    phone_number.insert(0, '(').insert(4, ')').insert(5, " ").insert(9, "-")
  end

  # This method needs a HUGE refactor:
  def find_dashboard_info
    owner_loans_with_puzzle = owner_loans.includes(:puzzle).where(status: [0, 1])
    borrower_loans_with_puzzle = borrower_loans.includes(:puzzle).where(status: [0, 1])

    dashboard_info = {
      id: id,
      user_info: {
        full_name: full_name,
        email: email,
        zip_code: zip_code,
        phone_number: phone_number
      },
      owner_loans: [],
      borrower_loans: []
    }

    owner_loans_with_puzzle.each do |loan|
      puzzle = loan.puzzle
      dashboard_info[:owner_loans] << {
        loan_id: loan.id,
        owner_id: loan.owner_id,
        borrower_id: loan.borrower_id,
        loan_status: loan.status,
        loan_created_at: loan.created_at,
        puzzle_id: loan.puzzle_id,
        puzzle_image_url: puzzle.puzzle_image_url,
        puzzle_title: puzzle.title,
        puzzle_status: puzzle.status
      }
    end

    borrower_loans_with_puzzle.each do |loan|
      puzzle = loan.puzzle
      dashboard_info[:borrower_loans] << {
        loan_id: loan.id,
        owner_id: loan.owner_id,
        borrower_id: loan.borrower_id,
        loan_status: loan.status,
        loan_created_at: loan.created_at,
        puzzle_id: loan.puzzle_id,
        puzzle_image_url: puzzle.puzzle_image_url,
        puzzle_title: puzzle.title,
        puzzle_status: puzzle.status
      }
    end

    OpenStruct.new(dashboard_info)
  end
end
