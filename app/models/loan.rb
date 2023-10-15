class Loan < ApplicationRecord
  belongs_to :owner_id
  belongs_to :borrower_id
  belongs_to :puzzle_id
end
