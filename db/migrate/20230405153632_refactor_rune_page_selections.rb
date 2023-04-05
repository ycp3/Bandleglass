class RefactorRunePageSelections < ActiveRecord::Migration[7.0]
  def change
    remove_column :rune_pages, :primary_rune_ids
    remove_column :rune_pages, :secondary_rune_ids

    add_reference :rune_pages, :row_1, foreign_key: { to_table: :runes }
    add_reference :rune_pages, :row_2, foreign_key: { to_table: :runes }
    add_reference :rune_pages, :row_3, foreign_key: { to_table: :runes }
    add_reference :rune_pages, :secondary_rune_1, foreign_key: { to_table: :runes }
    add_reference :rune_pages, :secondary_rune_2, foreign_key: { to_table: :runes }
  end
end
