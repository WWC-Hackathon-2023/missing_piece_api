class Api::V1::PuzzlesController < ApplicationController
  skip_before_action :set_current_user, only: [:index]

  def index
    zip_code = params[:zip_code]
    users = User.where(zip_code:) if zip_code.present?

    if users != []
      puzzles = Puzzle.where(user_id: users.pluck(:id))
      current_puzzles = puzzles.where.not(status: 3)
      render json: PuzzleSerializer.new(current_puzzles)
    elsif puzzles == [] || users == []
      render json: { error: "Puzzles not found in this area" }, status: "404"
    end
  end
end
