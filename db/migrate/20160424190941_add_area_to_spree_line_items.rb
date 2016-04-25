class AddAreaToSpreeLineItems < ActiveRecord::Migration
  def change
    add_column :spree_line_items, :area, :decimal, :precision => 8, :scale => 2
  end
end
