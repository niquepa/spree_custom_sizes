class AddTypeCalcToFinishing < ActiveRecord::Migration
  def change
    add_column :spree_finishings, :type_calc, :integer, default: 0
  end
end
