class CreateTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :teams do |t|
      t.references :match, foreign_key: true
      t.integer :team_id
      t.boolean :win

      t.boolean :first_baron
      t.integer :baron_kills
      t.boolean :first_champion
      t.integer :champion_kills
      t.boolean :first_dragon
      t.integer :dragon_kills
      t.boolean :first_inhibitor
      t.integer :inhibitor_kills
      t.boolean :first_rift_herald
      t.integer :rift_herald_kills
      t.boolean :first_tower
      t.integer :tower_kills

      t.timestamps
    end
  end
end
