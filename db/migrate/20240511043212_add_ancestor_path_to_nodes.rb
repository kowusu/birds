class AddAncestorPathToNodes < ActiveRecord::Migration[7.0]
  def change
    add_column :nodes, :ancestor_path, :integer, array: true, default: []
  end
end
