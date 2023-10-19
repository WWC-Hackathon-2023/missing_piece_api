class Api::V1::Users::PuzzlesController < ApplicationController

  def show
    user = User.find(params[:user_id])
    puzzle = user.puzzles.find(params[:puzzle_id])

    # puzzle = Puzzle.find_by(id: params[:puzzle_id], user_id: params[:user_id])
    render json: PuzzleSerializer.new(puzzle)
  end
end