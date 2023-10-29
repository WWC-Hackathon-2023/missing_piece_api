class Api::V1::PuzzlesController < ApplicationController
  skip_before_action :set_current_user, only: [:index]

  def index
    puzzles_in_zip_code = Puzzle.find_by_zip_code(params[:zip_code])

    if puzzles_in_zip_code.any?
      render json: PuzzleSerializer.new(puzzles_in_zip_code)
    else
      raise NoPuzzlesException
    end
  end
end
