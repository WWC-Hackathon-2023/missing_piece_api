class Api::V1::PuzzlesController < ApplicationController

  def index
      
      zip_code = params[:zip_code]

      @users = User.where(zip_code: zip_code) if zip_code.present?

      if @users.present?

        @puzzles = Puzzle.where(user_id: @users.pluck(:id))
        render json: @puzzles
      else
        puzzles = []
        render json: { error: "Puzzles not found in this area" }, status: :not_found
      end
  end

end