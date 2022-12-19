class AddOrnnUpgradeToItems < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :ornn_upgrade, :boolean
  end
end
