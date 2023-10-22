require 'rails_helper'

RSpec.describe 'UsersController' do
  describe '#show' do # Owner/Borrower Info Page
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
        expect(parsed_data[:data][:attributes].keys).to eq([:full_name, :email, :zip_code, :phone_number])
        expect(parsed_data[:data][:attributes][:full_name]).to eq(user_1.full_name)
        expect(parsed_data[:data][:attributes][:email]).to eq(user_1.email)
        expect(parsed_data[:data][:attributes][:zip_code]).to eq(user_1.zip_code)
        expect(parsed_data[:data][:attributes][:phone_number]).to eq(user_1.phone_number)
      end
    end

    context "when NOT successful" do
      it 'returns an error message when user_id is invalid' do
        create(:user, id: 1)

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

  describe '#dashboard' do
    before(:each) do
      @user_1 = create(:user, id: 1)
      @user_2 = create(:user, id: 2)
      @user_3 = create(:user, id: 3)
      @user_4 = create(:user, id: 4)

      5.times do
        create(:puzzle, user: @user_1)
      end

      4.times do
        create(:puzzle, user: @user_2)
      end

      3.times do
        create(:puzzle, user: @user_3)
      end

      2.times do
        create(:puzzle, user: @user_4)
      end

      @loan_1 = create(:loan, owner: @user_1, borrower: @user_2)
      @loan_2 = create(:loan, owner: @user_1, borrower: @user_3)
      @loan_3 = create(:loan, owner: @user_1, borrower: @user_4)

      @loan_4 = create(:loan, owner: @user_2, borrower: @user_1)
      @loan_5 = create(:loan, owner: @user_3, borrower: @user_1)
    end

    context "when successful" do
      it 'returns a single user, their attributes, & all loans owned/borrowed that are not "Closed"' do
        get "/api/v1/users/#{@user_1.id}/dashboard"

        expect(response).to have_http_status(200)

        parsed_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_data).to be_a(Hash)
        expect(parsed_data.keys).to eq([:data])
        expect(parsed_data[:data]).to be_a(Hash)
        expect(parsed_data[:data].keys).to eq([:id, :type, :attributes])

        expect(parsed_data[:data][:attributes]).to be_a(Hash)
        expect(parsed_data[:data][:attributes].keys).to eq([:user_info, :owner_loans, :borrower_loans])

        expect(parsed_data[:data][:attributes][:user_info]).to be_a(Hash)
        expect(parsed_data[:data][:attributes][:user_info].keys).to eq([:full_name, :email, :zip_code, :phone_number])
        expect(parsed_data[:data][:attributes][:user_info][:full_name]).to eq(@user_1.full_name)
        expect(parsed_data[:data][:attributes][:user_info][:email]).to eq(@user_1.email)
        expect(parsed_data[:data][:attributes][:user_info][:zip_code]).to eq(@user_1.zip_code)
        expect(parsed_data[:data][:attributes][:user_info][:phone_number]).to eq(@user_1.phone_number)

        expect(parsed_data[:data][:attributes][:owner_loans]).to be_an(Array)
        expect(parsed_data[:data][:attributes][:owner_loans].size).to eq(3)
        expect(parsed_data[:data][:attributes][:owner_loans][0]).to be_a(Hash)
        expect(parsed_data[:data][:attributes][:owner_loans][0].keys).to eq([:loan_id, :owner_id, :borrower_id, :loan_status, :loan_created_at, :puzzle_id, :puzzle_image_url, :puzzle_title,
                                                                             :puzzle_status])

        expect(parsed_data[:data][:attributes][:borrower_loans]).to be_an(Array)
        expect(parsed_data[:data][:attributes][:borrower_loans].size).to eq(2)
        expect(parsed_data[:data][:attributes][:borrower_loans][0]).to be_a(Hash)
        expect(parsed_data[:data][:attributes][:borrower_loans][0].keys).to eq([:loan_id, :owner_id, :borrower_id, :loan_status, :loan_created_at, :puzzle_id, :puzzle_image_url, :puzzle_title,
                                                                                :puzzle_status])
      end
    end

    context "when NOT successful" do
      it 'returns an error message when user_id is invalid' do
        get "/api/v1/users/007/dashboard"

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

  describe '#create' do
    context "when successful" do
      it 'creates a new user' do
        new_user_info = {
          full_name: "Nancy Puzzler",
          password: "puzzles4fun",
          password_confirmation: "puzzles4fun",
          email: "nancy@my_email.com",
          zip_code: 12_345,
          phone_number: 5_553_039_999
        }

        headers = { 'CONTENT_TYPE' => 'application/json' }
        post "/api/v1/users", headers:, params: JSON.generate(new_user_info)

        expect(response).to have_http_status(201)

        parsed_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_data).to be_a(Hash)
        expect(parsed_data.keys).to eq([:data])
        expect(parsed_data[:data]).to be_a(Hash)
        expect(parsed_data[:data].keys).to eq([:id, :type, :attributes])

        expect(parsed_data[:data][:attributes]).to be_a(Hash)
        expect(parsed_data[:data][:attributes].keys).to eq([:full_name, :email, :zip_code, :phone_number])
        expect(parsed_data[:data][:attributes][:full_name]).to eq(new_user_info[:full_name])
        expect(parsed_data[:data][:attributes][:email]).to eq(new_user_info[:email])
        expect(parsed_data[:data][:attributes][:zip_code]).to eq(new_user_info[:zip_code])
        expect(parsed_data[:data][:attributes][:phone_number]).to eq("(555) 303-9999")
        expect(parsed_data[:data][:attributes][:user_image_url]).to eq(new_user_info[:user_image_url])
      end
    end

    # context "when NOT successful" do
    # end
  end
end
