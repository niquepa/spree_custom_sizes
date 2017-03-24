class CreateFinishingLineItemsTable < ActiveRecord::Migration
  def change
    create_table :spree_finishing_line_items do |t|
      t.decimal :price_multiplier
      t.integer :quantity
      t.decimal :price_modifier
      t.string :location
      t.integer :width
      t.integer :height
      t.belongs_to :finishing
      t.belongs_to :line_item      
      t.timestamps null: false
    end
  end
end
