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

  describe "instance methods" do
    describe "#format_attributes" do
      it "can format the email & phone number attributes of a user" do
        user = User.create(
          full_name: "Diana Puzzler",
          password: "PuzzleQueen1",
          password_confirmation: "PuzzleQueen1",
          email: "DpuZZler@My-Email.coM",
          zip_code: 12345,
          phone_number: "1011110000"
        )

        user.format_attributes

        expect(user.email).to eq("dpuzzler@my-email.com")
        expect(user.phone_number).to eq("(101) 111-0000")
      end
    end

    describe "#find_dashboard_info" do
      before(:each) do
        @user_1 = create(:user, id: 1)
        @user_2 = create(:user, id: 2)
        @user_3 = create(:user, id: 3)
        @user_4 = create(:user, id: 4)

        5.times do
          create(:puzzle, user: @user_1)
        end

        5.times do
          create(:puzzle, user: @user_2)
        end

        5.times do
          create(:puzzle, user: @user_3)
        end

        2.times do
          create(:puzzle, user: @user_4)
        end

        # user_1 Owner Loans
        @loan_1 = create(:loan, owner: @user_1, borrower: @user_3) 
        @loan_2 = create(:loan, owner: @user_1, borrower: @user_3)
        @loan_3 = create(:loan, owner: @user_1, borrower: @user_4)

        # user_1 Borrower Loans
        @loan_4 = create(:loan, owner: @user_3, borrower: @user_1)
        @loan_5 = create(:loan, owner: @user_4, borrower: @user_1)

        # user_2 Borrower Loans
        @loan_6 = create(:loan, owner: @user_4, borrower: @user_2, status: 2)
        @loan_7 = create(:loan, owner: @user_3, borrower: @user_2, status: 3)
        @loan_8 = create(:loan, owner: @user_3, borrower: @user_2)
      end

      it "returns a Dashboard object with user_info, owner_loans, and borrower_loans" do
        user_1_info = {
          full_name: @user_1.full_name,
          email: @user_1.email,
          zip_code: @user_1.zip_code,
          phone_number: @user_1.phone_number
        }

        dashboard_info = @user_1.find_dashboard_info

        expect(dashboard_info).to be_an(OpenStruct)
        expect(dashboard_info.id).to eq(@user_1.id)
        expect(dashboard_info.user_info).to be_a(Hash)
        expect(dashboard_info.user_info).to eq(user_1_info)
        expect(dashboard_info.owner_loans).to be_an(Array)
        expect(dashboard_info.owner_loans.size).to eq(3)
        expect(dashboard_info.borrower_loans).to be_an(Array)
        expect(dashboard_info.borrower_loans.size).to eq(2)
      end

      it "does not return loans that are Cancelled(status:2) or Closed (status:3)" do
        user_2_info = {
          full_name: @user_2.full_name,
          email: @user_2.email,
          zip_code: @user_2.zip_code,
          phone_number: @user_2.phone_number
        }

        dashboard_info = @user_2.find_dashboard_info

        expect(dashboard_info).to be_an(OpenStruct)
        expect(dashboard_info.id).to eq(@user_2.id)
        expect(dashboard_info.user_info).to be_a(Hash)
        expect(dashboard_info.user_info).to eq(user_2_info)
        expect(dashboard_info.owner_loans).to be_an(Array)
        expect(dashboard_info.owner_loans.size).to eq(0)
        expect(dashboard_info.borrower_loans).to be_an(Array)
        expect(dashboard_info.borrower_loans.size).to eq(1)
      end
    end
  end
end
