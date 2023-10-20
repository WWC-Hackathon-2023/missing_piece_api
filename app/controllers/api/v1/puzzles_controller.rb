class Api::V1::PuzzlesController < ApplicationController

  def index
      
      zipcode = params[:zip_code]

      user = User.find_by(zip_code: zipcode)

      if user
        puzzles = user.puzzles.to_a
        render json: puzzles
      else
        puzzles = []
        render json: { error: "Puzzles not found in this area" }, status: :not_found
      end
  end

end