class AddLocationToFinishings < ActiveRecord::Migration
  def change
    add_column :spree_finishings, :loc_required, :boolean
  end
end
