class Loan < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  belongs_to :borrower, class_name: 'User', foreign_key: 'borrower_id'
  belongs_to :puzzle

  validates_presence_of :owner_id, :borrower_id, :puzzle_id, :status

  enum status: { 'Pending' => 0, 'Accepted' => 1, 'Cancelled' => 2, 'Closed' => 3 }
end
