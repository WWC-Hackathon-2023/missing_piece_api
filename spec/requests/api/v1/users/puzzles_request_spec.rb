require 'rails_helper'

RSpec.describe 'User/PuzzlesController' do
  describe '#show' do
    context "when successful" do
      it 'returns a single puzzle & its attributes' do
        user_1 = create(:user, id: 1)
        puzzle_1 = create(:puzzle, user: user_1)
        puzzle_2 = create(:puzzle, user: user_1)
        puzzle_3 = create(:puzzle, user: user_1)

        get "/api/v1/users/#{user_1.id}/puzzles/#{puzzle_1.id}"

        # these two expect statements have the same function so only one is needed:
        # expect(response).to be_successful 
        expect(response).to have_http_status(200)

        parsed_data = JSON.parse(response.body, symbolize_names: true)
      end
    end

    # context "when NOT successful" do
    # end
  end
end
