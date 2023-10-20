require 'rails_helper'

RSpec.describe 'User/PuzzlesController' do
  describe '#index' do # My Collection Page
    before(:each) do
      @user_1 = create(:user, id: 1)

      5.times do
        create(:puzzle, user: @user_1)
      end

      @puzzle_1 = @user_1.puzzles[0]
    end

    context "when successful" do
      it 'returns all puzzles that a user owns' do
        get "/api/v1/users/#{@user_1.id}/puzzles"

        expect(response).to have_http_status(200)

        parsed_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_data).to be_a(Hash)
        expect(parsed_data.keys).to eq([:data])
        expect(parsed_data[:data]).to be_an(Array)
        expect(parsed_data[:data][0].keys).to eq([:id, :type, :attributes])

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
    end

    context "when NOT successful" do
      it 'returns an error message when user_id is invalid' do
        get "/api/v1/users/007/puzzles"

        expect(response).to have_http_status(404)

        parsed_error_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_error_data).to be_a(Hash)
        expect(parsed_error_data.keys).to eq([:errors])
        expect(parsed_error_data[:errors]).to be_an(Array)
        expect(parsed_error_data[:errors][0].keys).to eq([:status, :title, :detail])
        expect(parsed_error_data[:errors][0][:status]).to eq("404")
        expect(parsed_error_data[:errors][0][:title]).to eq("ActiveRecord::RecordNotFound")
        expect(parsed_error_data[:errors][0][:detail]).to eq("Couldn't find User with 'id'=007")
      end
    end
  end

  describe '#show' do # Individual Puzzle Page
    context "when successful" do
      it 'returns a single puzzle & its attributes' do
        user_1 = create(:user, id: 1)
        puzzle_1 = create(:puzzle, user: user_1)
        puzzle_2 = create(:puzzle, user: user_1)

        get "/api/v1/users/#{user_1.id}/puzzles/#{puzzle_1.id}"

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

    context "when NOT successful" do
      it 'returns an error message when user_id is invalid' do
        user_1 = create(:user, id: 1)
        puzzle_1 = create(:puzzle, user: user_1)
        puzzle_2 = create(:puzzle, user: user_1)

        get "/api/v1/users/007/puzzles/#{puzzle_1.id}"

        expect(response).to have_http_status(404)

        parsed_error_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_error_data).to be_a(Hash)
        expect(parsed_error_data.keys).to eq([:errors])
        expect(parsed_error_data[:errors]).to be_an(Array)
        expect(parsed_error_data[:errors][0].keys).to eq([:status, :title, :detail])
        expect(parsed_error_data[:errors][0][:status]).to eq("404")
        expect(parsed_error_data[:errors][0][:title]).to eq("ActiveRecord::RecordNotFound")
        expect(parsed_error_data[:errors][0][:detail]).to eq("Couldn't find User with 'id'=007")
      end

      it 'returns an error message when puzzle_id is invalid' do
        user_1 = create(:user, id: 1)
        puzzle_1 = create(:puzzle, user: user_1)
        puzzle_2 = create(:puzzle, user: user_1)

        get "/api/v1/users/#{user_1.id}/puzzles/007"

        expect(response).to have_http_status(404)

        parsed_error_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_error_data).to be_a(Hash)
        expect(parsed_error_data.keys).to eq([:errors])
        expect(parsed_error_data[:errors]).to be_an(Array)
        expect(parsed_error_data[:errors][0].keys).to eq([:status, :title, :detail])
        expect(parsed_error_data[:errors][0][:status]).to eq("404")
        expect(parsed_error_data[:errors][0][:title]).to eq("ActiveRecord::RecordNotFound")
        expect(parsed_error_data[:errors][0][:detail]).to eq("Couldn't find Puzzle with 'id'=007 [WHERE \"puzzles\".\"user_id\" = $1]")

        # REFACTOR: to make error prettier to look at:
        # expect(parsed_error_data[:errors][0][:detail]).to eq("Couldn't find Puzzle with 'id'=007")
      end
    end
  end
end
