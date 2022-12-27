class RenameQueueToQueueType < ActiveRecord::Migration[7.0]
  def change
    rename_column :matches, :queue, :queue_type
    remove_column :matches, :game_mode
  end
end
