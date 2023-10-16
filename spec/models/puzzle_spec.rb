require 'rails_helper'

RSpec.describe Puzzle, type: :model do
  describe "relationships" do
    it { should belong_to :user }
    it { should have_many :loans }
  end
end
