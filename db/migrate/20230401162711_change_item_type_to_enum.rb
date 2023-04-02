class ChangeItemTypeToEnum < ActiveRecord::Migration[7.0]
  def change
    remove_column :items, :mythic
    remove_column :items, :ornn_upgrade
    add_column :items, :item_type, :integer, default: 0
  end
end
