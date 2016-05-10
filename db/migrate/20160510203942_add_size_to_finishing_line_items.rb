class AddSizeToFinishingLineItems < ActiveRecord::Migration
  def change
    add_column :spree_finishing_line_items, :size, :string
  end
end
