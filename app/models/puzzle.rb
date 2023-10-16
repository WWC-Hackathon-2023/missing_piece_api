class Puzzle < ApplicationRecord
  belongs_to :user
  has_many :loans, foreign_key: 'puzzle_id'

  enum status: { 'Available' => 0, 'Pending' => 1, 'Not Available' => 2 }
end
