require 'rails_helper'

RSpec.describe User, type: :model do
  describe "relationships" do
    it { should have_many :puzzles }
    it { should have_many(:owner_loans).class_name('Loan').with_foreign_key('owner_id') }
    it { should have_many(:borrower_loans).class_name('Loan').with_foreign_key('borrower_id') }
  end
end
