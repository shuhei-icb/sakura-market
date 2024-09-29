class CreateCartItems < ActiveRecord::Migration[7.1]
  def change
    create_table :cart_items do |t|
      t.references :cart, null: false, foreign_key: true, index: false
      t.references :product, null: false, foreign_key: true
      t.timestamps
    end
    add_index :cart_items, %i[cart_id product_id], unique: true
  end
end
