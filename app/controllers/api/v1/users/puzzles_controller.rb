class Api::V1::Users::PuzzlesController < ApplicationController
  def show
    render json: PuzzleSerializer.new(Puzzle.find(params[:puzzle_id]))
  end
end