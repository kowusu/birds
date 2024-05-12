class Bird < ActiveRecord::Migration[7.0]
  def change
    create_table :birds do |t|
      t.references :node, null: false, foreign_key: true

      t.timestamps
    end
  end
end
