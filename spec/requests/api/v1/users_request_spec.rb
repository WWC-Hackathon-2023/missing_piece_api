require 'rails_helper'

RSpec.describe 'UsersController' do
  describe '#show' do
    it 'returns a single user & their attributes' do
      user_1 = create(:user, id:1)
      user_2 = create(:user, id:2)

      get "/api/v1/users/#{user_1.id}"

      expect(response).to have_http_status(200)

      users = JSON.parse(response.body, symbolize_names: true)

      # require 'pry'; binding.pry
    end
  end
end