class CreateLoans < ActiveRecord::Migration[7.0]
  def change
    create_table :loans do |t|
      t.references :owner_id, null: false, foreign_key: { to_table: :users }
      t.references :borrower_id, null: false, foreign_key: { to_table: :users }
      t.references :puzzle_id, null: false, foreign_key: { to_table: :puzzles }
      t.integer :status, default: 1

      t.timestamps
    end
  end
end
