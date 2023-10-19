class User < ApplicationRecord
  has_many :puzzles
  has_many :owner_loans, class_name: 'Loan', foreign_key: 'owner_id'
  has_many :borrower_loans, class_name: 'Loan', foreign_key: 'borrower_id'

  validates_presence_of :full_name, :email, :zip_code, :phone_number
  validates :email, :phone_number, uniqueness: true
  validates_numericality_of :zip_code
end
