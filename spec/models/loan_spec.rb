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

    it { should define_enum_for(:status).with_values(%w[Pending Accepted Cancelled Closed]) }
  end

  describe "instance methods" do
    describe "#update_status_and_puzzle_status" do
      context "when successful" do
        before(:each) do
          @user_1 = create(:user, id: 1)
          @user_2 = create(:user, id: 2)
          # Unsure if forcing this status is best practice:
          # However, when a loan is created through the controller the puzzle status will change to Pending
          @puzzle_1 = create(:puzzle, user: @user_1, status: "Pending")

          @loan_1 = Loan.create(
            owner: @user_1,
            borrower: @user_2,
            puzzle: @puzzle_1,
            status: 0
          )
        end

        context "when loan action_type is accept" do
          it "returns a loan status Accepted & puzzle status Not Available" do
            expect(@loan_1.status).to eq("Pending") # loan_status = 0
            expect(@loan_1.puzzle.status).to eq("Pending") # puzzle_status = 1

            @loan_1.update_status_and_puzzle_status("accept")

            expect(@loan_1.status).to eq("Accepted") # loan_status = 1
            expect(@loan_1.puzzle.status).to eq("Not Available") # puzzle_status = 2
          end
        end

        context "when loan action_type is withdraw" do
          it "returns a loan status Cancelled & puzzle status Available" do
            expect(@loan_1.status).to eq("Pending") # loan_status = 0
            expect(@loan_1.puzzle.status).to eq("Pending") # puzzle_status = 1

            @loan_1.update_status_and_puzzle_status("withdraw")

            expect(@loan_1.status).to eq("Cancelled") # loan_status = 2
            expect(@loan_1.puzzle.status).to eq("Available") # puzzle_status = 0
          end
        end

        context "when loan action_type is deny" do
          it "returns a loan status Cancelled & puzzle status Not Available" do
            expect(@loan_1.status).to eq("Pending") # loan_status = 0
            expect(@loan_1.puzzle.status).to eq("Pending") # puzzle_status = 1

            @loan_1.update_status_and_puzzle_status("deny")

            expect(@loan_1.status).to eq("Cancelled") # loan_status = 2
            expect(@loan_1.puzzle.status).to eq("Not Available") # puzzle_status = 2
          end
        end

        context "when loan action_type is close" do
          it "returns a loan status Closed & puzzle status Available" do
            expect(@loan_1.status).to eq("Pending") # loan_status = 0
            expect(@loan_1.puzzle.status).to eq("Pending") # puzzle_status = 1

            @loan_1.update_status_and_puzzle_status("close")

            expect(@loan_1.status).to eq("Closed") # loan_status = 3
            expect(@loan_1.puzzle.status).to eq("Available") # puzzle_status = 0
          end
        end
      end

      context "when NOT successful" do
        before(:each) do
          @user_1 = create(:user, id: 1)
          @user_2 = create(:user, id: 2)
          # Unsure if forcing this status is best practice:
          # However, when a loan is created through the controller the puzzle status will change to Pending
          @puzzle_1 = create(:puzzle, user: @user_1, status: "Pending")

          @loan_1 = Loan.create(
            owner: @user_1,
            borrower: @user_2,
            puzzle: @puzzle_1,
            status: 0
          )
        end

        context "when a loan action_type is invalid" do
          it "raises a NoLoanUpdateException & loan/puzzle status is unchanged" do
            expect(@loan_1.status).to eq("Pending") # loan_status = 0
            expect(@loan_1.puzzle.status).to eq("Pending") # puzzle_status = 1

            # Squiggly brackets are necessary when expecting an exception when using RSpec's raise_error matcher
            expect { @loan_1.update_status_and_puzzle_status("invalid_action") }.to raise_error(NoLoanUpdateException)

            expect(@loan_1.status).to eq("Pending") # loan_status = 0
            expect(@loan_1.puzzle.status).to eq("Pending") # puzzle_status = 1
          end
        end

        context "when a loan action_type is nil" do
          it 'raises a NoLoanUpdateException & loan/puzzle status is unchanged' do
            expect(@loan_1.status).to eq("Pending") # loan_status = 0
            expect(@loan_1.puzzle.status).to eq("Pending") # puzzle_status = 1

            # Squiggly brackets are necessary when expecting an exception when using RSpec's raise_error matcher
            expect { @loan_1.update_status_and_puzzle_status(nil) }.to raise_error(NoLoanUpdateException)

            expect(@loan_1.status).to eq("Pending") # loan_status = 0
            expect(@loan_1.puzzle.status).to eq("Pending") # puzzle_status = 1
          end
        end
      end
    end
  end
end
