class CreateRunes < ActiveRecord::Migration[7.0]
  def change
    create_table :runes do |t|
      t.string :name
      t.references :rune_tree, foreign_key: true
      t.integer :row
      t.integer :row_order
      t.text :description
      t.string :file_name

      t.timestamps
    end
  end
end
