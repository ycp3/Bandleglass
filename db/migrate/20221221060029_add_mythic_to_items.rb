class AddMythicToItems < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :mythic, :boolean
  end
end
