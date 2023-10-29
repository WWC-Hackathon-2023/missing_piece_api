# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "PuzzlesController", type: :request do
  describe "#index" do
    context 'when successful' do
      before(:each) do
        @user_1 = create(:user, id: 1, zip_code: 12345)
        @user_2 = create(:user, id: 2, zip_code: 12345)
        @user_3 = create(:user, id: 3, zip_code: 54321)
        @user_4 = create(:user, id: 4, zip_code: 54321)
  
        @puzzle_1 = create(:puzzle, id: 1, user: @user_1)
        @puzzle_2 = create(:puzzle, id: 2, user: @user_1)
  
        @puzzle_3 = create(:puzzle, id: 3, user: @user_2)
        @puzzle_4 = create(:puzzle, id: 4, user: @user_2)
  
        @puzzle_5 = create(:puzzle, id: 5, user: @user_3)
        @puzzle_6 = create(:puzzle, id: 6, user: @user_3, status: 1)
  
        @puzzle_7 = create(:puzzle, id: 7, user: @user_4, status: 2)
        @puzzle_8 = create(:puzzle, id: 8, user: @user_4, status: 3)
      end

      it "returns all puzzles from a zipcode" do
        zip_code = 12345
        zipcode_params = { zip_code: zip_code }

        headers = { 'CONTENT_TYPE' => 'application/json' }
        put "/api/v1/puzzles", headers:, params: JSON.generate(zipcode_params)

        expect(response).to have_http_status(200)
        parsed_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_data).to be_a(Hash)
        expect(parsed_data.keys).to eq([:data])
        expect(parsed_data[:data]).to be_an(Array)
        expect(parsed_data[:data].size).to eq(4) # Only puzzles 1-4 are in this zip code
        expect(parsed_data[:data][0]).to be_a(Hash)
        expect(parsed_data[:data][0].keys).to eq([:id, :type, :attributes])

        expect(parsed_data[:data][0][:id]).to eq(@puzzle_1.id.to_s) 
        expect(parsed_data[:data][1][:id]).to eq(@puzzle_2.id.to_s) 
        expect(parsed_data[:data][2][:id]).to eq(@puzzle_3.id.to_s) 
        expect(parsed_data[:data][3][:id]).to eq(@puzzle_4.id.to_s) 

        expect(parsed_data[:data][0][:attributes]).to be_a(Hash)
        expect(parsed_data[:data][0][:attributes].keys).to eq([:user_id, :status, :title, :description, :total_pieces, :notes, :puzzle_image_url])
        expect(parsed_data[:data][0][:attributes][:user_id]).to eq(@puzzle_1.user_id)
        expect(parsed_data[:data][0][:attributes][:status]).to eq(@puzzle_1.status)
        expect(parsed_data[:data][0][:attributes][:title]).to eq(@puzzle_1.title)
        expect(parsed_data[:data][0][:attributes][:description]).to eq(@puzzle_1.description)
        expect(parsed_data[:data][0][:attributes][:total_pieces]).to eq(@puzzle_1.total_pieces)
        expect(parsed_data[:data][0][:attributes][:notes]).to eq(@puzzle_1.notes)
        expect(parsed_data[:data][0][:attributes][:puzzle_image_url]).to eq(@puzzle_1.puzzle_image_url)
      end

      it "does not return any puzzles with a status 3='Permanently Removed' from a zipcode" do
        zip_code = 54321
        zipcode_params = { zip_code: zip_code }

        headers = { 'CONTENT_TYPE' => 'application/json' }
        put "/api/v1/puzzles", headers:, params: JSON.generate(zipcode_params)

        expect(response).to have_http_status(200)
        parsed_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_data).to be_a(Hash)
        expect(parsed_data.keys).to eq([:data])
        expect(parsed_data[:data]).to be_an(Array)
        expect(parsed_data[:data].size).to eq(3) # Only puzzles 5-7 are in this zip code without a status=3
        expect(parsed_data[:data][0]).to be_a(Hash)
        expect(parsed_data[:data][0].keys).to eq([:id, :type, :attributes])

        expect(parsed_data[:data][0][:id]).to eq(@puzzle_5.id.to_s)
        expect(parsed_data[:data][1][:id]).to eq(@puzzle_6.id.to_s)
        expect(parsed_data[:data][2][:id]).to eq(@puzzle_7.id.to_s)

        expect(parsed_data[:data][0][:attributes]).to be_a(Hash)
        expect(parsed_data[:data][0][:attributes].keys).to eq([:user_id, :status, :title, :description, :total_pieces, :notes, :puzzle_image_url])
        expect(parsed_data[:data][0][:attributes][:user_id]).to eq(@puzzle_5.user_id)
        expect(parsed_data[:data][0][:attributes][:status]).to eq(@puzzle_5.status)
        expect(parsed_data[:data][0][:attributes][:title]).to eq(@puzzle_5.title)
        expect(parsed_data[:data][0][:attributes][:description]).to eq(@puzzle_5.description)
        expect(parsed_data[:data][0][:attributes][:total_pieces]).to eq(@puzzle_5.total_pieces)
        expect(parsed_data[:data][0][:attributes][:notes]).to eq(@puzzle_5.notes)
        expect(parsed_data[:data][0][:attributes][:puzzle_image_url]).to eq(@puzzle_5.puzzle_image_url)
      end
    end

    context 'when NOT successful' do
      before(:each) do
        @user_1 = create(:user, id: 1, zip_code: 12345)
        @user_2 = create(:user, id: 2, zip_code: 12345)
        @user_3 = create(:user, id: 3, zip_code: 54321)
  
        @puzzle_1 = create(:puzzle, id: 1, user: @user_1)
        @puzzle_2 = create(:puzzle, id: 2, user: @user_1)
  
        @puzzle_3 = create(:puzzle, id: 3, user: @user_2)
        @puzzle_4 = create(:puzzle, id: 4, user: @user_2)
      end

      it 'returns a NoPuzzlesException error when zipcode is not found' do
        zip_code = 10101
        zipcode_params = { zip_code: zip_code }

        headers = { 'CONTENT_TYPE' => 'application/json' }
        put "/api/v1/puzzles", headers:, params: JSON.generate(zipcode_params)

        expect(response).to have_http_status(404)
        parsed_error_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_error_data).to be_a(Hash)
        expect(parsed_error_data.keys).to eq([:errors])
        expect(parsed_error_data[:errors]).to be_an(Array)
        expect(parsed_error_data[:errors][0]).to be_a(Hash)
        expect(parsed_error_data[:errors][0].keys).to eq([:status, :title, :detail])
        expect(parsed_error_data[:errors][0][:status]).to eq("404")
        expect(parsed_error_data[:errors][0][:title]).to eq("NoPuzzlesFoundException")
        expect(parsed_error_data[:errors][0][:detail]).to eq("No puzzles found in this area.")
      end

      it 'returns a NoPuzzlesException error when no puzzles are found in a zip code that does exists in the database' do
        zip_code = 54321 # A user exists in this zip code but has no puzzles
        zipcode_params = { zip_code: zip_code }

        headers = { 'CONTENT_TYPE' => 'application/json' }
        put "/api/v1/puzzles", headers:, params: JSON.generate(zipcode_params)

        expect(response).to have_http_status(404)
        parsed_error_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_error_data).to be_a(Hash)
        expect(parsed_error_data.keys).to eq([:errors])
        expect(parsed_error_data[:errors]).to be_an(Array)
        expect(parsed_error_data[:errors][0]).to be_a(Hash)
        expect(parsed_error_data[:errors][0].keys).to eq([:status, :title, :detail])
        expect(parsed_error_data[:errors][0][:status]).to eq("404")
        expect(parsed_error_data[:errors][0][:title]).to eq("NoPuzzlesFoundException")
        expect(parsed_error_data[:errors][0][:detail]).to eq("No puzzles found in this area.")
      end

      it 'returns a NoPuzzlesException error when nil is sent as zip code' do
        zip_code = nil 
        zipcode_params = { zip_code: zip_code }

        headers = { 'CONTENT_TYPE' => 'application/json' }
        put "/api/v1/puzzles", headers:, params: JSON.generate(zipcode_params)

        expect(response).to have_http_status(404)
        parsed_error_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_error_data).to be_a(Hash)
        expect(parsed_error_data.keys).to eq([:errors])
        expect(parsed_error_data[:errors]).to be_an(Array)
        expect(parsed_error_data[:errors][0]).to be_a(Hash)
        expect(parsed_error_data[:errors][0].keys).to eq([:status, :title, :detail])
        expect(parsed_error_data[:errors][0][:status]).to eq("404")
        expect(parsed_error_data[:errors][0][:title]).to eq("NoPuzzlesFoundException")
        expect(parsed_error_data[:errors][0][:detail]).to eq("No puzzles found in this area.")
      end
    end
  end
end
