require 'rails_helper'

RSpec.describe 'SessionsController' do
  describe '#create' do
    before(:each) do
      @user = User.create(
        full_name: "Diana Puzzler",
        password: "PuzzleQueen1",
        password_confirmation: "PuzzleQueen1",
        email: "dpuzzler@myemail.com", # The Users#create will format the email in this way before it is saved to the db
        zip_code: 12345,
        phone_number: "(555) 000-9999" # The Users#create will format the phone_number in this way before it is saved to the db
      )
    end

    context 'when successful' do
      it 'logs in a user' do
        login_data = {
          email: "dpuzzler@myemail.com",
          password: "PuzzleQueen1"
        }

        headers = { 'CONTENT_TYPE' => 'application/json' }
        post "/api/v1/login", headers:, params: JSON.generate(login_data)

        expect(response).to have_http_status(201)
        parsed_data = JSON.parse(response.body, symbolize_names: true)

        expect(session[:user_id]).to eq(@user.id)
      end
    end

    context 'when NOT successful' do
      it 'cannot log in a user with an incorrect password' do
        login_data = {
          email: "dpuzzler@myemail.com",
          password: "Queen_of_Puzzles"
        }

        headers = { 'CONTENT_TYPE' => 'application/json' }
        post "/api/v1/login", headers:, params: JSON.generate(login_data)

        expect(response).to have_http_status(401)
        parsed_error_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_error_data).to be_a(Hash)
        expect(parsed_error_data.keys).to eq([:errors])
        expect(parsed_error_data[:errors]).to be_an(Array)
        expect(parsed_error_data[:errors][0]).to be_a(Hash)
        expect(parsed_error_data[:errors][0].keys).to eq([:status, :title, :detail])
        expect(parsed_error_data[:errors][0][:status]).to eq("401")
        expect(parsed_error_data[:errors][0][:title]).to eq("InvalidAuthenticationException")
        expect(parsed_error_data[:errors][0][:detail]).to eq("Invalid email or password.")
      end

      it 'cannot log in a user with a missing email and password' do
        login_data = {
          email: nil,
          password: nil
        }

        headers = { 'CONTENT_TYPE' => 'application/json' }
        post "/api/v1/login", headers:, params: JSON.generate(login_data)

        expect(response).to have_http_status(401)
        parsed_error_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_error_data).to be_a(Hash)
        expect(parsed_error_data.keys).to eq([:errors])
        expect(parsed_error_data[:errors]).to be_an(Array)
        expect(parsed_error_data[:errors][0]).to be_a(Hash)
        expect(parsed_error_data[:errors][0].keys).to eq([:status, :title, :detail])
        expect(parsed_error_data[:errors][0][:status]).to eq("401")
        expect(parsed_error_data[:errors][0][:title]).to eq("MissingAuthenticationException")
        expect(parsed_error_data[:errors][0][:detail]).to eq("Email and password are required.")
      end
    end
  end

  describe '#destroy' do
    context 'when successful' do
      it 'deletes a user session' do
        user = create(:user)
        login_data = { email: user.email, password: user.password }

        headers = { 'CONTENT_TYPE' => 'application/json' }
        post "/api/v1/login", headers:, params: JSON.generate(login_data)

        expect(response).to have_http_status(201)
        expect(session[:user_id]).to eq(user.id)

        delete "/api/v1/users/#{user.id}/logout"

        expect(response).to have_http_status(204)
        expect(session[:user_id]).to be_nil
      end
    end

    context 'when NOT successful' do
      # Unsure how to test this:

      # it 'cannot delete a user session of another user' do
      #   user = create(:user)
      #   login_data = { email: user.email, password: user.password }

      #   headers = { 'CONTENT_TYPE' => 'application/json' }
      #   post "/api/v1/users/#{user.id}/login", headers:, params: JSON.generate(login_data)

      #   expect(response).to have_http_status(201)
      #   expect(session[:user_id]).to eq(user.id)

      #   delete "/api/v1/users/007/logout"

      #   expect(response).to have_http_status(401)
      #   expect(session[:user_id]).to eq(user.id)
      # end
    end
  end
end
