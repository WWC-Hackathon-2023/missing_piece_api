require 'rails_helper'

RSpec.describe 'Users/LoansController' do
  describe '#create' do
    # let(:user_1) { create(:user, id: 1) }
    # let(:user_2) { create(:user, id: 2) }
    # let(:puzzle_1) { create(:puzzle, user: user_1) }
    # let(:loan_1) { create(:loan, owner: user_1, borrower: user_2) }
    
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

        expect(response).to have_http_status(201)
        expect(puzzle_1.status).to eq("Pending")

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
        puzzle_1 = create(:puzzle, user: user_1, status: 1) #Puzzle status 1 = "Pending"

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
        puzzle_1 = create(:puzzle, user: user_1, status: 2) #Puzzle status 2 = "Not Available"

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
    let(:user_1) { create(:user) }
    let(:user_2) { create(:user) }
    let(:puzzle_1) { create(:puzzle) }
    let(:loan_2) { create(:loan, owner: user_1, borrower: user_2, puzzle: puzzle_1) }

    context "when successful" do
      it 'updates loan status to Accepted when loan action type is Accept' do
        # FE will send us an new param called action_type to know which button the user clicked
        # action types: "accept," "deny", "withdraw", or "close"
        loan_update = {
          action_type: "accept"
        }

        expect(puzzle_1.status).to eq("Pending")

        headers = { 'CONTENT_TYPE' => 'application/json' }
        patch "/api/v1/users/#{user_1.id}/loans/#{loan_2.id}", headers:, params: JSON.generate(loan_update)

        expect(response).to have_http_status(200)
        expect(puzzle_1.status).to eq("Not Available")

        parsed_data = JSON.parse(response.body, symbolize_names: true)
        expect(parsed_data[:data][:attributes][:status]).to eq("Accepted")
      end

      it 'updates loan status to Cancelled when loan action type is Withdraw' do
        # FE will send us an new param called action_type to know which button the user clicked
        # action types: "accept," "deny", "withdraw", or "close"
        loan_update = {
          action_type: "withdraw", 
        }

        headers = { 'CONTENT_TYPE' => 'application/json' }
        patch "/api/v1/users/#{user_1.id}/loans/#{loan_2.id}", headers:, params: JSON.generate(loan_update)

        expect(response).to have_http_status(200)

        parsed_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_data).to be_a(Hash)
        expect(parsed_data.keys).to eq([:data])
        expect(parsed_data[:data]).to be_an(Hash)
        expect(parsed_data[:data].keys).to eq([:id, :type, :attributes])

        expect(parsed_data[:data][:attributes]).to be_a(Hash)
        expect(parsed_data[:data][:attributes].keys).to eq([:owner_id, :borrower_id, :puzzle_id, :status])
        expect(parsed_data[:data][:attributes][:status]).to eq("Cancelled")
      end

      it 'updates loan status to Cancelled when loan action type is Deny' do
        # FE will send us an new param called action_type to know which button the user clicked
        # action types: "accept," "deny", "withdraw", or "close"
        loan_update = {
          action_type: "deny", 
        }

        headers = { 'CONTENT_TYPE' => 'application/json' }
        patch "/api/v1/users/#{user_1.id}/loans/#{loan_2.id}", headers:, params: JSON.generate(loan_update)

        expect(response).to have_http_status(200)

        parsed_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_data).to be_a(Hash)
        expect(parsed_data.keys).to eq([:data])
        expect(parsed_data[:data]).to be_an(Hash)
        expect(parsed_data[:data].keys).to eq([:id, :type, :attributes])

        expect(parsed_data[:data][:attributes]).to be_a(Hash)
        expect(parsed_data[:data][:attributes].keys).to eq([:owner_id, :borrower_id, :puzzle_id, :status])
        expect(parsed_data[:data][:attributes][:status]).to eq("Cancelled")
      end

      it 'updates loan status to Closed when loan action type is Close' do
        # FE will send us an new param called action_type to know which button the user clicked
        # action types: "accept," "deny", "withdraw", or "close"
        loan_update = {
          action_type: "close", 
        }

        headers = { 'CONTENT_TYPE' => 'application/json' }
        patch "/api/v1/users/#{user_1.id}/loans/#{loan_2.id}", headers:, params: JSON.generate(loan_update)

        expect(response).to have_http_status(200)

        parsed_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_data).to be_a(Hash)
        expect(parsed_data.keys).to eq([:data])
        expect(parsed_data[:data]).to be_an(Hash)
        expect(parsed_data[:data].keys).to eq([:id, :type, :attributes])

        expect(parsed_data[:data][:attributes]).to be_a(Hash)
        expect(parsed_data[:data][:attributes].keys).to eq([:owner_id, :borrower_id, :puzzle_id, :status])
        expect(parsed_data[:data][:attributes][:status]).to eq("Closed")
      end


      # it 'updates loan status to 2 when status is withdraw' do
      #   patch "/api/v1/users/#{user_1.id}/loans/#{loan_2.id}", params: {
      #     id: user_1.id, loan_id: loan_2.id, action_type: 'withdraw'
      #   }

      #   expect(response).to have_http_status(200)
      #   expect(loan_2.reload.status).to eq('Cancelled')

      #   parsed_data = JSON.parse(response.body, symbolize_names: true)

      #   expect(parsed_data).to be_a(Hash)
      #   expect(parsed_data.keys).to eq([:data])
      #   expect(parsed_data[:data]).to be_an(Hash)
      #   expect(parsed_data[:data].keys).to eq([:id, :type, :attributes])

      #   expect(parsed_data[:data][:attributes]).to be_a(Hash)
      #   expect(parsed_data[:data][:attributes].keys).to eq([:owner_id, :borrower_id, :puzzle_id, :status])
      #   expect(parsed_data[:data][:attributes][:owner_id]).to eq(loan_2.owner_id)
      #   expect(parsed_data[:data][:attributes][:borrower_id]).to eq(loan_2.borrower_id)
      #   expect(parsed_data[:data][:attributes][:puzzle_id]).to eq(loan_2.puzzle_id)
      #   expect(parsed_data[:data][:attributes][:status]).to eq(loan_2.status)
      # end
    end

    context "when NOT successful" do
      xit 'returns an error message when an action type is invalid' do
        patch "/api/v1/users/#{user_1.id}/loans/#{loan_2.id}", params: {
          id: user_1.id, loan_id: loan_2.id, action_type: 'invalid_action'
        }

        expect(response).to have_http_status(422)

        parsed_error_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_error_data).to be_a(Hash)
        expect(parsed_error_data.keys).to eq([:error])
        expect(parsed_error_data[:error]).to eq("Invalid action")
      end

      before do
        allow_any_instance_of(Loan).to receive(:update).and_return(false)
      end

      xit 'returns an error message when loan update fails' do
        patch "/api/v1/users/#{user_1.id}/loans/#{loan_2.id}", params: {
          id: user_1.id, loan_id: loan_2.id, action_type: 'deny'
        }

        expect(response).to have_http_status(422)

        parsed_error_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_error_data).to be_a(Hash)
        expect(parsed_error_data.keys).to eq([:error])
        expect(parsed_error_data[:error]).to eq("Unable to update loan status")
      end
    end
  end
end
