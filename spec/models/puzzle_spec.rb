require 'rails_helper'

RSpec.describe Puzzle, type: :model do
  describe "relationships" do
    it { should belong_to :user }
    it { should have_many :loans }
  end

  describe "validations" do
    it { should define_enum_for(:status).with_values(["Available", "Pending", "Not Available"]) }
  end
end
