require 'rails_helper'

RSpec.describe 'UsersController' do
  describe '#show' do
    context "when successful" do
      it 'returns a single user & their attributes' do
        user_1 = create(:user, id: 1)

        get "/api/v1/users/#{user_1.id}"

        expect(response).to have_http_status(200)

        parsed_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_data).to be_a(Hash)
        expect(parsed_data.keys).to eq([:data])
        expect(parsed_data[:data]).to be_a(Hash)
        expect(parsed_data[:data].keys).to eq([:id, :type, :attributes])

        expect(parsed_data[:data][:attributes]).to be_a(Hash)
        expect(parsed_data[:data][:attributes].keys).to eq([:full_name, :email, :zip_code, :phone_number, :user_image_url])
        expect(parsed_data[:data][:attributes][:full_name]).to eq(user_1.full_name)
        expect(parsed_data[:data][:attributes][:email]).to eq(user_1.email)
        expect(parsed_data[:data][:attributes][:zip_code]).to eq(user_1.zip_code) 
        expect(parsed_data[:data][:attributes][:phone_number]).to eq(user_1.phone_number)
        expect(parsed_data[:data][:attributes][:user_image_url]).to eq(user_1.user_image_url)
      end
    end

    context "when NOT successful" do
      it 'returns an error message when user_id is invalid' do
        user_1 = create(:user, id:1)

        get "/api/v1/users/007"
 
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
end