class CreateMatches < ActiveRecord::Migration[7.0]
  def change
    create_table :matches do |t|
      t.string :match_id, index: { unique: true }
      t.integer :region
      t.datetime :started_at
      t.integer :duration
      t.integer :game_mode
      t.integer :game_type
      t.string :game_version
      t.integer :map_id
      t.integer :queue_id

      t.timestamps
    end
  end
end
