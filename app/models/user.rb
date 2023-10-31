require 'ostruct'

class User < ApplicationRecord
  has_many :puzzles
  has_many :owner_loans, class_name: 'Loan', foreign_key: 'owner_id'
  has_many :borrower_loans, class_name: 'Loan', foreign_key: 'borrower_id'

  validates_presence_of :full_name, :email, :zip_code, :phone_number, :password, :password_confirmation
  validates_uniqueness_of :email, :phone_number
  validates_numericality_of :zip_code

  has_secure_password

  def format_attributes
    self.email = format_email
    self.phone_number = format_phone_number
  end

  def find_dashboard_info
    dashboard = create_dashboard_with_user_info
    updated_dashboard = find_owner_loans_with_puzzle(dashboard)
    complete_dashboard = find_borrower_loans_with_puzzle(updated_dashboard)
    OpenStruct.new(complete_dashboard)
  end

  private

  def format_email
    email.downcase
  end

  def format_phone_number
    phone_number.insert(0, '(').insert(4, ')').insert(5, " ").insert(9, "-")
  end

  def create_dashboard_with_user_info
    {
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
  end

  def find_owner_loans_with_puzzle(dashboard)
    owner_loans_with_puzzle = owner_loans.includes(:puzzle).where(status: [0, 1])

    dashboard[:owner_loans] = owner_loans_with_puzzle.map do |loan|
      puzzle = loan.puzzle
      {
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

    dashboard
  end

  def find_borrower_loans_with_puzzle(dashboard)
    borrower_loans_with_puzzle = borrower_loans.includes(:puzzle).where(status: [0, 1])

    dashboard[:borrower_loans] = borrower_loans_with_puzzle.map do |loan|
      puzzle = loan.puzzle
      {
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

    dashboard
  end
end
