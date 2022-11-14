class CreateSummoners < ActiveRecord::Migration[7.0]
  def change
    create_table :summoners do |t|
      t.string :name
      t.integer :region
      t.string :encrypted_id
      t.string :puuid
      t.integer :profile_icon_id
      t.integer :level

      t.timestamps
    end
  end
end
