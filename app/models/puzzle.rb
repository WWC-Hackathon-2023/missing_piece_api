class Puzzle < ApplicationRecord
  belongs_to :user
  has_many :loans, foreign_key: 'puzzle_id'
end
