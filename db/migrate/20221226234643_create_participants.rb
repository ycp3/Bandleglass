class CreateParticipants < ActiveRecord::Migration[7.0]
  def change
    create_table :participants do |t|
      t.references :summoner, foreign_key: true
      t.references :match, foreign_key: true
      t.references :team, foreign_key: true

      t.references :champion, foreign_key: true
      t.references :ban, foreign_key: { to_table: :champions }

      t.references :summoner_spell_1, foreign_key: { to_table: :summoner_spells }
      t.references :summoner_spell_2, foreign_key: { to_table: :summoner_spells }

      t.string :name
      t.integer :level
      t.integer :profile_icon_id
      t.integer :cached_tier
      t.integer :cached_division
      t.integer :cached_lp

      t.integer :kills
      t.integer :deaths
      t.integer :assists

      t.integer :champion_level
      t.integer :champion_transform
      t.integer :position

      t.integer :gold_earned
      t.integer :largest_multikill
      t.integer :damage_dealt
      t.integer :damage_taken
      t.integer :minions_killed
      t.integer :vision_score

      t.timestamps
    end
  end
end
