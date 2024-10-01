class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.integer :payment_amount, null: false
      t.integer :cash_on_delivery, null: false
      t.integer :shipping_fee, null: false
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
