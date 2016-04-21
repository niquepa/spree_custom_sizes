class AddWeightToSpreeLineItems < ActiveRecord::Migration
  def change
    add_column :spree_line_items, :weight, :decimal, :precision => 8, :scale => 2
  end
end
