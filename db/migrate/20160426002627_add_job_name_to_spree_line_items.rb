class AddJobNameToSpreeLineItems < ActiveRecord::Migration
  def change
    add_column :spree_line_items, :job_name, :string
  end
end
