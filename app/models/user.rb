class User < ApplicationRecord
  has_many :puzzles
  has_many :owner_loans, class_name: 'Loan', foreign_key: 'owner_id'
  has_many :borrower_loans, class_name: 'Loan', foreign_key: 'borrower_id'
end
