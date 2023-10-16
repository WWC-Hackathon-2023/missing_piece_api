require 'rails_helper'

RSpec.describe Loan, type: :model do
  describe "relationships" do
    it { should belong_to :owner }
    it { should belong_to :borrower }
    it { should belong_to :puzzle }
  end

  describe "validations" do
    it { should define_enum_for(:status).with_values(["Pending", "Accepted", "Denied", "Closed"]) }
  end
end
