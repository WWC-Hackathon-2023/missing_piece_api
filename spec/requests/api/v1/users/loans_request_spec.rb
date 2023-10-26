require 'rails_helper'

RSpec.describe 'Users/LoansController' do
  describe '#create' do
    context "when successful" do
      it 'creates a new loan' do
        user_1 = create(:user, id: 1)
        user_2 = create(:user, id: 2)
        puzzle_1 = create(:puzzle, user: user_1)

        expect(puzzle_1.status).to eq("Available")

        loan_request = {
          puzzle_id: puzzle_1.id,
          borrower_id: user_2.id
        }

        headers = { 'CONTENT_TYPE' => 'application/json' }
        post "/api/v1/users/#{user_1.id}/loans", headers:, params: JSON.generate(loan_request)

        expect(Loan.last.puzzle.status).to eq("Pending")
        expect(response).to have_http_status(201)

        parsed_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_data).to be_a(Hash)
        expect(parsed_data.keys).to eq([:data])
        expect(parsed_data[:data]).to be_an(Hash)
        expect(parsed_data[:data].keys).to eq([:id, :type, :attributes])

        expect(parsed_data[:data][:attributes]).to be_a(Hash)
        expect(parsed_data[:data][:attributes].keys).to eq([:owner_id, :borrower_id, :puzzle_id, :status])
        expect(parsed_data[:data][:attributes][:owner_id]).to eq(user_1.id)
        expect(parsed_data[:data][:attributes][:borrower_id]).to eq(user_2.id)
        expect(parsed_data[:data][:attributes][:puzzle_id]).to eq(puzzle_1.id)
        expect(parsed_data[:data][:attributes][:status]).to eq("Pending")
      end
    end

    context "when NOT successful" do
      it 'returns an error message if trying to make the same loan twice' do
        user_1 = create(:user, id: 1)
        user_2 = create(:user, id: 2)
        puzzle_1 = create(:puzzle, user: user_1)

        create(:loan, owner: user_1, borrower: user_2, puzzle: puzzle_1)
        allow(Loan).to receive(:new).and_return(double(save: false))

        post "/api/v1/users/#{user_1.id}/loans", params: {
          puzzle_id: puzzle_1.id,
          borrower_id: user_2.id
        }

        expect(response).to have_http_status(422)

        parsed_error_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_error_data).to be_a(Hash)
        expect(parsed_error_data.keys).to eq([:error])
        expect(parsed_error_data[:error]).to eq("Unable to create loan")
      end

      it 'returns an error message if trying to make a loan when a Puzzle status is Pending' do
        user_1 = create(:user, id: 1)
        user_2 = create(:user, id: 2)
        puzzle_1 = create(:puzzle, user: user_1, status: 1) # Puzzle status 1 = "Pending"

        post "/api/v1/users/#{user_1.id}/loans", params: {
          puzzle_id: puzzle_1.id,
          borrower_id: user_2.id
        }

        expect(response).to have_http_status(422)

        parsed_error_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_error_data).to be_a(Hash)
        expect(parsed_error_data.keys).to eq([:error])
        expect(parsed_error_data[:error]).to eq("Puzzle is not available for loan.")
      end

      it 'returns an error message if trying to make a loan when a Puzzle status is Not Available' do
        user_1 = create(:user, id: 1)
        user_2 = create(:user, id: 2)
        puzzle_1 = create(:puzzle, user: user_1, status: 2) # Puzzle status 2 = "Not Available"

        post "/api/v1/users/#{user_1.id}/loans", params: {
          puzzle_id: puzzle_1.id,
          borrower_id: user_2.id
        }

        expect(response).to have_http_status(422)

        parsed_error_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_error_data).to be_a(Hash)
        expect(parsed_error_data.keys).to eq([:error])
        expect(parsed_error_data[:error]).to eq("Puzzle is not available for loan.")
      end

      it 'returns an error message if trying to make a loan when a Puzzle status is Permanently Removed' do
        user_1 = create(:user, id: 1)
        user_2 = create(:user, id: 2)
        puzzle_1 = create(:puzzle, user: user_1, status: 3) # Puzzle status 3 = "Permanently Removed"

        post "/api/v1/users/#{user_1.id}/loans", params: {
          puzzle_id: puzzle_1.id,
          borrower_id: user_2.id
        }

        expect(response).to have_http_status(422)

        parsed_error_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_error_data).to be_a(Hash)
        expect(parsed_error_data.keys).to eq([:error])
        expect(parsed_error_data[:error]).to eq("Puzzle is not available for loan.")
      end
    end
  end

  describe '#update' do
    before(:each) do
      @user_1 = create(:user, id: 1)
      @user_2 = create(:user, id: 2)
      @puzzle_1 = create(:puzzle, user: @user_1)

      loan_request = {
        puzzle_id: @puzzle_1.id,
        borrower_id: @user_2.id
      }

      headers = { 'CONTENT_TYPE' => 'application/json' }
      post "/api/v1/users/#{@user_1.id}/loans", headers:, params: JSON.generate(loan_request)
      
      @current_loan = Loan.last
    end

    context "when successful" do
      #REFACTOR: the following tests test both the puzzle status and the loan status changes

      it 'updates loan status to Accepted when loan action type is Accept' do
        expect(@current_loan.puzzle.status).to eq("Pending")

        loan_update = { action_type: "accept" }

        headers = { 'CONTENT_TYPE' => 'application/json' }
        patch "/api/v1/users/#{@user_1.id}/loans/#{@current_loan.id}", headers:, params: JSON.generate(loan_update)

        @current_loan.reload
        expect(@current_loan.puzzle.status).to eq("Not Available")

        expect(response).to have_http_status(200)
        parsed_data = JSON.parse(response.body, symbolize_names: true)
        expect(parsed_data[:data][:attributes][:status]).to eq("Accepted")
      end

      it 'updates loan status to Cancelled when loan action type is Withdraw' do
        expect(@current_loan.puzzle.status).to eq("Pending")

        loan_update = { action_type: "withdraw" }

        headers = { 'CONTENT_TYPE' => 'application/json' }
        patch "/api/v1/users/#{@user_1.id}/loans/#{@current_loan.id}", headers:, params: JSON.generate(loan_update)

        @current_loan.reload
        expect(@current_loan.puzzle.status).to eq("Available")

        expect(response).to have_http_status(200)
        parsed_data = JSON.parse(response.body, symbolize_names: true)
        expect(parsed_data[:data][:attributes][:status]).to eq("Cancelled")
      end

      it 'updates loan status to Cancelled when loan action type is Deny' do
        expect(@current_loan.puzzle.status).to eq("Pending")

        loan_update = { action_type: "deny" }

        headers = { 'CONTENT_TYPE' => 'application/json' }
        patch "/api/v1/users/#{@user_1.id}/loans/#{@current_loan.id}", headers:, params: JSON.generate(loan_update)

        @current_loan.reload
        expect(@current_loan.puzzle.status).to eq("Not Available")

        expect(response).to have_http_status(200)
        parsed_data = JSON.parse(response.body, symbolize_names: true)
        expect(parsed_data[:data][:attributes][:status]).to eq("Cancelled")
      end

      it 'updates loan status to Closed when loan action type is Close' do
        expect(@current_loan.puzzle.status).to eq("Pending")

        loan_update = { action_type: "close" }

        headers = { 'CONTENT_TYPE' => 'application/json' }
        patch "/api/v1/users/#{@user_1.id}/loans/#{@current_loan.id}", headers:, params: JSON.generate(loan_update)

        @current_loan.reload
        expect(@current_loan.puzzle.status).to eq("Available")

        expect(response).to have_http_status(200)
        parsed_data = JSON.parse(response.body, symbolize_names: true)
        expect(parsed_data[:data][:attributes][:status]).to eq("Closed")
      end
    end

    context "when NOT successful" do
      it 'returns an error message when an action type is invalid' do
        expect(@current_loan.puzzle.status).to eq("Pending")

        loan_update = { action_type: "puzzled" }

        headers = { 'CONTENT_TYPE' => 'application/json' }
        patch "/api/v1/users/#{@user_1.id}/loans/#{@current_loan.id}", headers:, params: JSON.generate(loan_update)

        @current_loan.reload
        expect(@current_loan.puzzle.status).to eq("Pending")

        expect(response).to have_http_status(422)
        parsed_error_data = JSON.parse(response.body, symbolize_names: true)
        expect(parsed_error_data).to be_a(Hash)
        expect(parsed_error_data.keys).to eq([:error])
        expect(parsed_error_data[:error]).to eq("Unable to update loan status")
      end

      it 'returns an error message when loan update fails' do
        allow_any_instance_of(Loan).to receive(:update).and_return(false)
        expect(@current_loan.puzzle.status).to eq("Pending")

        loan_update = { action_type: "accepted" }

        headers = { 'CONTENT_TYPE' => 'application/json' }
        patch "/api/v1/users/#{@user_1.id}/loans/#{@current_loan.id}", headers:, params: JSON.generate(loan_update)

        @current_loan.reload
        expect(@current_loan.puzzle.status).to eq("Pending")

        expect(response).to have_http_status(422)
        parsed_error_data = JSON.parse(response.body, symbolize_names: true)
        expect(parsed_error_data).to be_a(Hash)
        expect(parsed_error_data.keys).to eq([:error])
        expect(parsed_error_data[:error]).to eq("Unable to update loan status")
      end
    end
  end
end
