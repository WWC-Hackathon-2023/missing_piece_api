require 'rails_helper'

RSpec.describe Loan, type: :model do
  describe "relationships" do
    it { should belong_to :owner }
    it { should belong_to :borrower }
    it { should belong_to :puzzle }
  end

  describe "validations" do
    it { should validate_presence_of :owner_id }
    it { should validate_presence_of :borrower_id }
    it { should validate_presence_of :puzzle_id }
    it { should validate_presence_of :status }

    it { should define_enum_for(:status).with_values(["Pending", "Accepted", "Cancelled", "Closed"]) }
  end
end
