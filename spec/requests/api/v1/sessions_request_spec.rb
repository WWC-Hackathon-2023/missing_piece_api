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
          phone_number: 5550009999 
        )

        login_data = {
          email: "dpuzzler@myemail.com",
          password: "PuzzleQueen1"
        }

        headers = { 'CONTENT_TYPE' => 'application/json' }
        post '/api/v1/login', headers: headers, params: JSON.generate(login_data)

        expect(response).to have_http_status(201)

        parsed_data = JSON.parse(response.body, symbolize_names: true)
      end
    end

    # context 'when NOT successful' do
    # end
  end

  describe '#destroy' do
    context 'when successful' do
      it 'deletes a user session' do
        user = create(:user)
        login_data = { email: user.email, password: user.password }

        headers = { 'CONTENT_TYPE' => 'application/json' }
        post '/api/v1/login', headers: headers, params: JSON.generate(login_data)

        expect(response).to have_http_status(201)

        token = JSON.parse(response.body)['token']

        delete '/api/v1/logout', headers: { 'Authorization' => "Bearer #{token}" }

        expect(response).to have_http_status(204)

        expect(session[:user_id]).to be_nil
      end
    end

    # context 'when NOT successful' do
    # end
  end
end
