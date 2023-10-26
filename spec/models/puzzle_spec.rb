require 'rails_helper'

RSpec.describe Puzzle, type: :model do
  describe "relationships" do
    it { should belong_to :user }
    it { should have_many :loans }
  end

  describe "validations" do
    it { should validate_presence_of :user_id }
    it { should validate_presence_of :status }
    it { should validate_presence_of :title }
    it { should validate_presence_of :description }
    it { should validate_presence_of :total_pieces }
    it { should validate_numericality_of :total_pieces }
    it { should validate_presence_of :puzzle_image_url }

    it { should define_enum_for(:status).with_values(["Available", "Pending", "Not Available", "Permanently Removed"]) }
  end
end
