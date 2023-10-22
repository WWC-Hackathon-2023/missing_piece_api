require 'rails_helper'

RSpec.describe 'Users/LoansController' do
  describe '#create' do
      let(:user_1) {  create(:user, id: 1 ) }
      let(:user_2) { create(:user, id: 2) }
      let(:puzzle_1) { create(:puzzle, user: user_1) }
      let(:loan_1) { create(:loan, owner: user_1, borrower: user_2) }
    context "when successful" do
      it 'creates a new loan' do
        post "/api/v1/users/#{user_1.id}/loans", params: {
          puzzle_id: puzzle_1.id,
          borrower_id: loan_1.borrower.id
        }

        expect(response).to have_http_status(201)

        parsed_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_data).to be_a(Hash)
        expect(parsed_data.keys).to eq([:data])
        expect(parsed_data[:data]).to be_an(Hash)
        expect(parsed_data[:data].keys).to eq([:id, :type, :attributes])

        expect(parsed_data[:data][:attributes]).to be_a(Hash)
        expect(parsed_data[:data][:attributes].keys).to eq([:owner_id, :borrower_id, :puzzle_id, :status])
        expect(parsed_data[:data][:attributes][:owner_id]).to eq(loan_1.owner_id)
        expect(parsed_data[:data][:attributes][:borrower_id]).to eq(loan_1.borrower_id)
        expect(parsed_data[:data][:attributes][:puzzle_id]).to eq(loan_1.puzzle_id)
        expect(parsed_data[:data][:attributes][:status]).to eq(loan_1.status)
      end
    end

    context "when NOT successful" do
      it 'creates an error message' do
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
    end
  end

  describe '#update' do
      let(:user_1) { create(:user) }
      let(:user_2) { create(:user) }
      let(:puzzle_1) { create(:puzzle)}
      let(:loan_2) { create(:loan, owner: user_1, borrower: user_2, puzzle: puzzle_1) }
      
    context "when successful" do
      it 'updates loan status to 2 when status is deny' do
        patch "/api/v1/users/#{user_1.id}/loans/#{loan_2.id}", params: { 
          id: user_1.id, loan_id: loan_2.id, action_type: 'deny' 
        }

        expect(response).to have_http_status(200)
        expect(loan_2.reload.status).to eq('Cancelled')

        parsed_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_data).to be_a(Hash)
        expect(parsed_data.keys).to eq([:data])
        expect(parsed_data[:data]).to be_an(Hash)
        expect(parsed_data[:data].keys).to eq([:id, :type, :attributes])

        expect(parsed_data[:data][:attributes]).to be_a(Hash)
        expect(parsed_data[:data][:attributes].keys).to eq([:owner_id, :borrower_id, :puzzle_id, :status])
        expect(parsed_data[:data][:attributes][:owner_id]).to eq(loan_2.owner_id)
        expect(parsed_data[:data][:attributes][:borrower_id]).to eq(loan_2.borrower_id)
        expect(parsed_data[:data][:attributes][:puzzle_id]).to eq(loan_2.puzzle_id)
        expect(parsed_data[:data][:attributes][:status]).to eq(loan_2.status)
    end

    it 'updates loan status to 2 when status is withdraw' do
      patch "/api/v1/users/#{user_1.id}/loans/#{loan_2.id}", params: { 
        id: user_1.id, loan_id: loan_2.id, action_type: 'withdraw' 
      }

      expect(response).to have_http_status(200)
      expect(loan_2.reload.status).to eq('Cancelled')

      parsed_data = JSON.parse(response.body, symbolize_names: true)

      expect(parsed_data).to be_a(Hash)
      expect(parsed_data.keys).to eq([:data])
      expect(parsed_data[:data]).to be_an(Hash)
      expect(parsed_data[:data].keys).to eq([:id, :type, :attributes])

      expect(parsed_data[:data][:attributes]).to be_a(Hash)
      expect(parsed_data[:data][:attributes].keys).to eq([:owner_id, :borrower_id, :puzzle_id, :status])
      expect(parsed_data[:data][:attributes][:owner_id]).to eq(loan_2.owner_id)
      expect(parsed_data[:data][:attributes][:borrower_id]).to eq(loan_2.borrower_id)
      expect(parsed_data[:data][:attributes][:puzzle_id]).to eq(loan_2.puzzle_id)
      expect(parsed_data[:data][:attributes][:status]).to eq(loan_2.status)
    end
  end

  context "when NOT successful" do
    it 'returns an error message when an action type is invalid' do

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

    it 'returns an error message when loan update fails' do

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
