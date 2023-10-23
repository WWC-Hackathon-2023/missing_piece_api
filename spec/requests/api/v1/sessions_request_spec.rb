require 'rails_helper'

RSpec.describe 'SessionsController' do
  describe '#create' do
    context 'when successful' do
      it 'logs in a user' do
        user = User.create(
          full_name: "Diana Puzzler",
          password: "PuzzleQueen1",
          password_confirmation: "PuzzleQueen1",
          email: "dpuzzler@myemail.com",
          zip_code: 12345,
          phone_number: 5500009999
        )

        login_data = {
          email: "dpuzzler@myemail.com",
          password: "PuzzleQueen1"
        }

        headers = { 'CONTENT_TYPE' => 'application/json' }
        post "/api/v1/login", headers:, params: JSON.generate(login_data)

        expect(response).to have_http_status(201)
        expect(session[:user_id]).to eq(user.id)
      end
    end

    context 'when NOT successful' do
      it 'cannot log in a user with an incorrect password' do
        user = User.create(
          full_name: "Diana Puzzler",
          password: "PuzzleQueen1",
          password_confirmation: "PuzzleQueen1",
          email: "dpuzzler@myemail.com",
          zip_code: 12345,
          phone_number: 5550009999
        )

        login_data = {
          email: "dpuzzler@myemail.com",
          password: "Queen_of_Puzzles"
        }

        headers = { 'CONTENT_TYPE' => 'application/json' }
        post "/api/v1/login", headers:, params: JSON.generate(login_data)

        expect(response).to have_http_status(401)

        parsed_error_data = JSON.parse(response.body, symbolize_names: true)

        expect(parsed_error_data).to be_a(Hash)
        expect(parsed_error_data.keys).to eq([:error])
        expect(parsed_error_data[:error]).to eq("Invalid email or password")
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
