class CreateCarts < ActiveRecord::Migration[7.1]
  def change
    create_table :carts do |t|
      t.references :user, foreign_key: true, index: false
      t.timestamps
    end
    add_index :carts, :user_id, unique: true
  end
end
