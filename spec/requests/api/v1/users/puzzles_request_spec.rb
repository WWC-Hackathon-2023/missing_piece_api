require 'rails_helper'

RSpec.describe 'User/PuzzlesController' do
  describe '#show' do
    context "when successful" do
      it 'returns a single puzzle & its attributes' do
        user_1 = create(:user, id: 1)
        puzzle_1 = create(:puzzle, user: user_1)
        puzzle_2 = create(:puzzle, user: user_1)

        get "/api/v1/users/#{user_1.id}/puzzles/#{puzzle_1.id}"

        # these two expect statements have the same function so only one is needed:
        # expect(response).to be_successful 
        expect(response).to have_http_status(200)

        parsed_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_data).to be_a(Hash)
        expect(parsed_data.keys).to eq([:data])
        expect(parsed_data[:data]).to be_a(Hash)
        expect(parsed_data[:data].keys).to eq([:id, :type, :attributes])

        expect(parsed_data[:data][:attributes]).to be_a(Hash)
        expect(parsed_data[:data][:attributes].keys).to eq([:user_id, :status, :title, :description, :total_pieces, :notes, :puzzle_image_url])
        expect(parsed_data[:data][:attributes][:user_id]).to eq(puzzle_1.user_id)
        expect(parsed_data[:data][:attributes][:status]).to eq(puzzle_1.status)
        expect(parsed_data[:data][:attributes][:title]).to eq(puzzle_1.title) 
        expect(parsed_data[:data][:attributes][:description]).to eq(puzzle_1.description)
        expect(parsed_data[:data][:attributes][:total_pieces]).to eq(puzzle_1.total_pieces)
        expect(parsed_data[:data][:attributes][:notes]).to eq(puzzle_1.notes)
        expect(parsed_data[:data][:attributes][:puzzle_image_url]).to eq(puzzle_1.puzzle_image_url)
      end
    end

    # context "when NOT successful" do
    # end
  end
end
