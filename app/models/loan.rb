class Loan < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  belongs_to :borrower, class_name: 'User', foreign_key: 'borrower_id'
  belongs_to :puzzle

  validates_presence_of :owner_id, :borrower_id, :puzzle_id, :status

  enum status: { 'Pending' => 0, 'Accepted' => 1, 'Cancelled' => 2, 'Closed' => 3 }

  def update_status_and_puzzle_status(action_type)
    loan_status, puzzle_status = case action_type
      when 'accept' then [1, 2]
      when 'withdraw' then [2, 0]
      when 'deny' then [2, 2]
      when 'close' then [3, 0]
      else raise NoLoanUpdateException
    end
    change_loan_and_puzzle_status(loan_status, puzzle_status)
    self
  end
  
  private 

  def change_loan_and_puzzle_status(loan_status, puzzle_status)
    self.update!(status: loan_status)
    self.puzzle.update!(status: puzzle_status)
  end
end

# Note to self: Saving this to remember process that lead me to final version:
# def update_status_and_puzzle_status(action_type)
#   case action_type
#   when 'accept'
#     change_loan_and_puzzle_status(1, 2)
#   when 'withdraw'
#     change_loan_and_puzzle_status(2, 0)
#   when 'deny'
#     change_loan_and_puzzle_status(2, 2)
#   when 'close'
#     change_loan_and_puzzle_status(3, 0)
#   else
#     raise NoLoanUpdateException
#   end
# end