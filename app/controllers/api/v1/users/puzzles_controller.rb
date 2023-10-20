class Api::V1::Users::PuzzlesController < ApplicationController

  def show
    user = User.find(params[:user_id])
    puzzle = user.puzzles.find(params[:puzzle_id])
    render json: PuzzleSerializer.new(puzzle)
  end
end