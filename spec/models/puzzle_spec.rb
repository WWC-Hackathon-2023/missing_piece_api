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

  describe "class methods" do
    describe "::find_by_zip_code" do
      before(:each) do
        @user_1 = create(:user, id: 1, zip_code: 12345)
        @user_2 = create(:user, id: 2, zip_code: 12345)
        @user_3 = create(:user, id: 3, zip_code: 54321)

        @puzzle_1 = create(:puzzle, user: @user_1)
        @puzzle_2 = create(:puzzle, user: @user_1)

        @puzzle_3 = create(:puzzle, user: @user_2)
        @puzzle_4 = create(:puzzle, user: @user_2)

        @puzzle_5 = create(:puzzle, user: @user_3)
        @puzzle_6 = create(:puzzle, user: @user_3)
      end

      it "returns all puzzles within a zip code" do
        puzzles_in_zip_code = Puzzle.find_by_zip_code(12345)

        expect(puzzles_in_zip_code).to eq([@puzzle_1, @puzzle_2, @puzzle_3, @puzzle_4])
        expect(puzzles_in_zip_code).to_not include([@puzzle_5, @puzzle_6])
      end

      it "returns an empty array if no puzzles are found in a zip code" do
        puzzles_in_zip_code = Puzzle.find_by_zip_code(10101)

        expect(puzzles_in_zip_code).to eq([])
        expect(puzzles_in_zip_code).to_not include([@puzzle_1, @puzzle_2, @puzzle_3, @puzzle_4, @puzzle_5, @puzzle_6])
      end

      it "returns an empty array if nil is sent in place of a zip code" do
        puzzles_in_zip_code = Puzzle.find_by_zip_code(nil)

        expect(puzzles_in_zip_code).to eq([])
        expect(puzzles_in_zip_code).to_not include([@puzzle_1, @puzzle_2, @puzzle_3, @puzzle_4, @puzzle_5, @puzzle_6])
      end
    end
  end
end
