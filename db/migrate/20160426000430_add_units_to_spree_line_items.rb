class AddUnitsToSpreeLineItems < ActiveRecord::Migration
  def change
    add_column :spree_line_items, :unit, :string
  end
end
