class CreateSummonerSpells < ActiveRecord::Migration[7.0]
  def change
    create_table :summoner_spells do |t|
      t.string :name
      t.string :internal_name
      t.text :description
      t.integer :cooldown

      t.timestamps
    end
  end
end
