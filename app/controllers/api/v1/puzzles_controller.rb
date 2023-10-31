class Api::V1::PuzzlesController < ApplicationController
  skip_before_action :set_current_user, only: [:index]

  def index
    find_puzzles(params[:zip_code])
    raise NoPuzzlesFoundException if @puzzles_in_zip_code.empty?
    render json: PuzzleSerializer.new(@puzzles_in_zip_code)
  end

  private

  def find_puzzles(zip_code)
    @puzzles_in_zip_code = Puzzle.find_by_zip_code(zip_code)
  end
end

# Note to self: Saving this to remember process that lead me to final version:
# def index
# puzzles_in_zip_code = Puzzle.find_by_zip_code(params[:zip_code])
# if @puzzles_in_zip_code.any?
#   render json: PuzzleSerializer.new(@puzzles_in_zip_code)
# else
#   raise NoPuzzlesException
# end
# end
