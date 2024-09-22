class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.integer :price, null: false
      t.text :description, default: '', null: false
      t.boolean :published, default: false, null: false
      t.integer :position, null: false
      t.timestamps
    end
  end
end
