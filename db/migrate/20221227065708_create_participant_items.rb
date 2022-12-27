class CreateParticipantItems < ActiveRecord::Migration[7.0]
  def change
    create_table :participant_items do |t|
      t.references :participant, foreign_key: true
      t.references :item, foreign_key: true

      t.integer :slot

      t.timestamps
    end
  end
end
