class CreateRunePages < ActiveRecord::Migration[7.0]
  def change
    create_table :rune_pages do |t|
      t.references :participant, foreign_key: true

      t.references :primary_tree, foreign_key: { to_table: :rune_trees }
      t.references :keystone, foreign_key: { to_table: :runes }
      t.integer :primary_rune_ids, array: true, default: []
      t.references :secondary_tree, foreign_key: { to_table: :rune_trees }
      t.integer :secondary_rune_ids, array: true, default: []

      t.integer :offense_stat
      t.integer :flex_stat
      t.integer :defense_stat

      t.timestamps
    end
  end
end
