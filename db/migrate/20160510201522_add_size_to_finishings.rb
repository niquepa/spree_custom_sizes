class AddSizeToFinishings < ActiveRecord::Migration
  def change
    add_column :spree_finishings, :size_required, :boolean
  end
end
