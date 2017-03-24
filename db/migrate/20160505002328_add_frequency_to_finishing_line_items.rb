class AddFrequencyToFinishingLineItems < ActiveRecord::Migration
  def change
    add_column :spree_finishing_line_items, :frequency, :integer
  end
end
