class CreateRanks < ActiveRecord::Migration[7.0]
  def change
    create_table :ranks do |t|
      t.references :summoner, foreign_key: true

      t.integer :queue_type
      t.integer :tier
      t.integer :division
      t.integer :lp
      t.integer :wins
      t.integer :losses

      t.timestamps
    end
  end
end
