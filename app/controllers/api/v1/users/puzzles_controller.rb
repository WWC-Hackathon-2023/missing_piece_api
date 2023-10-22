class Api::V1::Users::PuzzlesController < ApplicationController
  before_action :find_user

  def index
    render json: PuzzleSerializer.new(@user.puzzles)
  end

  def show
    puzzle = @user.puzzles.find(params[:puzzle_id])
    render json: PuzzleSerializer.new(puzzle)
  end

  def create
    puzzle = @user.puzzles.new(puzzle_params)
    render json: PuzzleSerializer.new(puzzle), status: 201 if puzzle.save
  end

  def update
    puzzle = Puzzle.find(params[:puzzle_id])

    puzzle.update(puzzle_params)
    render json: PuzzleSerializer.new(puzzle)
  end

  private

  def puzzle_params
    params.permit(:status, :title, :description, :total_pieces, :notes, :puzzle_image_url) # did not include user_id
  end

  def find_user
    @user = User.find(params[:user_id])
  end
end
