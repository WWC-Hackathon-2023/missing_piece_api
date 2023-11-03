class Puzzle < ApplicationRecord
  belongs_to :user
  has_many :loans, foreign_key: 'puzzle_id'

  validates_presence_of :user_id, :status, :title, :description, :total_pieces, :puzzle_image_url
  validates_numericality_of :total_pieces

  enum status: { 'Available' => 0, 'Pending' => 1, 'Not Available' => 2, "Permanently Removed" => 3 }

  # scope is chainable (easily combined with other methods)
  # if it's a commonly used query & you want to make it easily chainable with other query conditions, using scope is a good choice.
  # scope :find_by_zip_code, ->(zip_code) {
  #   joins(:user)
  #     .where(users: { zip_code: zip_code })
  #     .where.not(status: 3)
  # }

  # if the query is highly specific or needs complex, dynamic conditions, leaving it as a class method might be more appropriate.
  def self.find_by_zip_code(zip_code)
    joins(:user)
      .where(users: { zip_code: zip_code })
      .where.not(status: 3)
  end
end
