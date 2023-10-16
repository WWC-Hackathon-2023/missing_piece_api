class CreateLoans < ActiveRecord::Migration[7.0]
  def change
    create_table :loans do |t|
      t.references :owner, null: false, foreign_key: { to_table: :users }
      t.references :borrower, null: false, foreign_key: { to_table: :users }
      t.references :puzzle, null: false, foreign_key: { to_table: :puzzles }
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
