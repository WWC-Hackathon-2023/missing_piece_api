class Api::V1::Users::PuzzlesController < ApplicationController
  before_action :find_user
  before_action :find_puzzle, only: [:update]

  def index
    render json: PuzzleSerializer.new(@user.puzzles)
  end

  def show
    show_puzzle = @user.puzzles.find(params[:puzzle_id])
    render json: PuzzleSerializer.new(show_puzzle)
  end

  def create
    new_puzzle = @user.puzzles.new(puzzle_params)
    render json: PuzzleSerializer.new(new_puzzle), status: 201 if new_puzzle.save
  end

  def update
    @puzzle.update(puzzle_params)
    render json: PuzzleSerializer.new(@puzzle)
  end

  private

  def puzzle_params
    params.permit(:status, :title, :description, :total_pieces, :notes, :puzzle_image_url) # did not include user_id since this will not be updated & is available when created already
  end

  def find_user
    @user = User.find(params[:user_id])
  end

  def find_puzzle
    @puzzle = Puzzle.find(params[:puzzle_id])
  end
end
