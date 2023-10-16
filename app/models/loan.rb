class Loan < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  belongs_to :borrower, class_name: 'User', foreign_key: 'borrower_id'
  belongs_to :puzzle
end
