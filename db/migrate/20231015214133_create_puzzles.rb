class CreatePuzzles < ActiveRecord::Migration[7.0]
  def change
    create_table :puzzles do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :status, default: 0
      t.string :title
      t.string :description
      t.integer :total_pieces
      t.string :notes
      t.string :puzzle_image_url

      t.timestamps
    end
  end
end
