class CreateOrderItems < ActiveRecord::Migration[7.1]
  def change
    create_table :order_items do |t|
      t.integer :price, null: false
      t.references :order, null: false, foreign_key: true, index: false
      t.references :product, null: false, foreign_key: true
      t.timestamps
    end
    add_index :order_items, %i[order_id product_id], unique: true
  end
end
