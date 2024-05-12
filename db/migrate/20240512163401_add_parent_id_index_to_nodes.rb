class AddParentIdIndexToNodes < ActiveRecord::Migration[7.0]
  def change
    add_index :nodes, :parent_id
  end
end
