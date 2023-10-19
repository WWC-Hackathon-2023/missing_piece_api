require 'rails_helper'

RSpec.describe User, type: :model do
  describe "relationships" do
    it { should have_many :puzzles }
    it { should have_many(:owner_loans).class_name('Loan').with_foreign_key('owner_id') }
    it { should have_many(:borrower_loans).class_name('Loan').with_foreign_key('borrower_id') }
  end

  describe "validations" do
    it { should validate_presence_of :full_name }
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
    it { should validate_presence_of :zip_code }
    it { should validate_numericality_of :zip_code }
    it { should validate_presence_of :phone_number }
    it { should validate_uniqueness_of :phone_number }
  end
end
