class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :full_name
      t.string :password_digest
      t.string :email
      t.integer :zip_code
      t.string :phone_number
      t.string :user_image_url

      t.timestamps
    end
  end
end
