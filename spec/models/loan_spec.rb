require 'rails_helper'

RSpec.describe Loan, type: :model do
  describe "relationships" do
    it { should belong_to :owner }
    it { should belong_to :borrower }
    it { should belong_to :puzzle }
  end
end
