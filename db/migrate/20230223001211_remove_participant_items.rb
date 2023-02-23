class RemoveParticipantItems < ActiveRecord::Migration[7.0]
  def change
    drop_table :participant_items

    add_column :participants, :items, :integer, array: true, default: []
  end
end
