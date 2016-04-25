class AddPerimeterToSpreeLineItems < ActiveRecord::Migration
  def change
    add_column :spree_line_items, :perimeter, :decimal, :precision => 8, :scale => 2
  end
end
