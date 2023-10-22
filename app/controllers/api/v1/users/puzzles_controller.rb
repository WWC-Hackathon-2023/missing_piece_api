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

  def create
    user = User.find(params[:user_id])
    puzzle = user.puzzles.build(puzzle_params)
    render json: PuzzleSerializer.new(puzzle), status: 201 if puzzle.save
  end

  def update
    User.find(params[:user_id])
    puzzle = Puzzle.find(params[:puzzle_id])

    puzzle.update(puzzle_params)
    render json: PuzzleSerializer.new(puzzle)
  end

        private

        def puzzle_params
          params.permit(:status, :title, :description, :total_pieces, :notes, :puzzle_image_url) # did not include user_id
        end
      end
    end
  end
end
