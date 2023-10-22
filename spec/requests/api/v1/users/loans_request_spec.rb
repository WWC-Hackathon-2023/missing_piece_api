require 'rails_helper'

RSpec.describe 'Users/LoansController' do
  describe '#create' do
    context "when successful" do
      it 'creates a new loan' do
        user_1 = create(:user, id: 1)
        user_2 = create(:user, id: 2)
        puzzle_1 = create(:puzzle, user: user_1)
        
        post "/api/v1/users/#{user_1.id}/loans", params: {
          puzzle_id: puzzle_1.id,
          borrower_id: user_2.id
        }

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
end
