class AddWidthToSpreeLineItems < ActiveRecord::Migration
  def change
    add_column :spree_line_items, :width, :decimal, :precision => 8, :scale => 2
  end
end
