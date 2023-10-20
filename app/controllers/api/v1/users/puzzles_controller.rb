class Api::V1::Users::PuzzlesController < ApplicationController

  def index
    user = User.find(params[:user_id])
    render json: PuzzleSerializer.new(user.puzzles)
  end

  def show
    user = User.find(params[:user_id])
    puzzle = user.puzzles.find(params[:puzzle_id])
    render json: PuzzleSerializer.new(puzzle)
  end
end