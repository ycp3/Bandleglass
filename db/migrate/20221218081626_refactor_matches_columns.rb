class RefactorMatchesColumns < ActiveRecord::Migration[7.0]
  def change
    remove_column :matches, :game_type
    rename_column :matches, :map_id, :map
    rename_column :matches, :queue_id, :queue
  end
end
