class Puzzle < ApplicationRecord
  belongs_to :user
  has_many :loans, foreign_key: 'puzzle_id'

  validates_presence_of :user_id, :status, :title, :description, :total_pieces, :puzzle_image_url, presence: true
  validates_numericality_of :total_pieces

  enum status: { 'Available' => 0, 'Pending' => 1, 'Not Available' => 2 }
end
