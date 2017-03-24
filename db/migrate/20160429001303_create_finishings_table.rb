class CreateFinishingsTable < ActiveRecord::Migration
  def change
    create_table :spree_finishings do |t|
      t.string :name
      t.string :presentation
      t.decimal :price_multiplier, :precision => 8, :scale => 2
      t.integer :frequency
      t.integer :parent
      t.integer :position
      t.belongs_to :product
      t.timestamps null: false
    end
  end
end
