# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "PuzzlesController", type: :request do
  describe "#index" do
    context 'when successful' do
      it "returns all puzzles from a zipcode" do
        zip_code = 12345

        user_1 = create(:user, id: 1, zip_code:)
        user_2 = create(:user, id: 2, zip_code:)
        user_3 = create(:user, id: 3, zip_code: 54321)
        puzzle_1 = create(:puzzle, user: user_1)
        create(:puzzle, user: user_1)
        puzzle_3 = create(:puzzle, user: user_2)
        create(:puzzle, user: user_3)

        zipcode_params = { zip_code: 12345 }

        headers = { 'CONTENT_TYPE' => 'application/json' }
        put "/api/v1/puzzles", headers:, params: JSON.generate(zipcode_params)

        expect(response).to have_http_status(200)

        parsed_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_data).to be_a(Hash)
        expect(parsed_data.keys).to eq([:data])
        expect(parsed_data[:data]).to be_an(Array)
        expect(parsed_data[:data][0]).to be_a(Hash)
        expect(parsed_data[:data][0].keys).to eq([:id, :type, :attributes])

        expect(parsed_data[:data][0][:attributes]).to be_a(Hash)
        expect(parsed_data[:data][0][:attributes].keys).to eq([:user_id, :status, :title, :description, :total_pieces, :notes, :puzzle_image_url])
        expect(parsed_data[:data][0][:attributes][:user_id]).to eq(puzzle_1.user_id)
        expect(parsed_data[:data][0][:attributes][:status]).to eq(puzzle_1.status)
        expect(parsed_data[:data][0][:attributes][:title]).to eq(puzzle_1.title)
        expect(parsed_data[:data][0][:attributes][:description]).to eq(puzzle_1.description)
        expect(parsed_data[:data][0][:attributes][:total_pieces]).to eq(puzzle_1.total_pieces)
        expect(parsed_data[:data][0][:attributes][:notes]).to eq(puzzle_1.notes)
        expect(parsed_data[:data][0][:attributes][:puzzle_image_url]).to eq(puzzle_1.puzzle_image_url)

        # NOTE: Could refactor tests to not see a puzzle_4 in the test because it's in a diff zipcode

        expect(parsed_data[:data][2][:attributes]).to be_a(Hash)
        expect(parsed_data[:data][2][:attributes].keys).to eq([:user_id, :status, :title, :description, :total_pieces, :notes, :puzzle_image_url])
        expect(parsed_data[:data][2][:attributes][:user_id]).to eq(puzzle_3.user_id)
        expect(parsed_data[:data][2][:attributes][:status]).to eq(puzzle_3.status)
        expect(parsed_data[:data][2][:attributes][:title]).to eq(puzzle_3.title)
        expect(parsed_data[:data][2][:attributes][:description]).to eq(puzzle_3.description)
        expect(parsed_data[:data][2][:attributes][:total_pieces]).to eq(puzzle_3.total_pieces)
        expect(parsed_data[:data][2][:attributes][:notes]).to eq(puzzle_3.notes)
        expect(parsed_data[:data][2][:attributes][:puzzle_image_url]).to eq(puzzle_3.puzzle_image_url)
      end
    end

    context 'when NOT successful' do
      it 'returns an error message when zipcode is not found' do
        user_1 = create(:user, id: 1, zip_code: 54321)
        user_2 = create(:user, id: 2, zip_code: 12346)
        create(:puzzle, user: user_1)
        create(:puzzle, user: user_1)
        create(:puzzle, user: user_2)
        create(:puzzle, user: user_2)

        zipcode_params = { zip_code: 0o0000 }

        headers = { 'CONTENT_TYPE' => 'application/json' }
        put "/api/v1/puzzles", headers:, params: JSON.generate(zipcode_params)

        expect(response).to have_http_status(404)

        parsed_error_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_error_data).to be_a(Hash)
        expect(parsed_error_data.keys).to eq([:error])
        expect(parsed_error_data[:error]).to eq("Puzzles not found in this area")
      end
    end
  end
end
