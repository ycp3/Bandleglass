class CreatePerformances < ActiveRecord::Migration[7.0]
  def change
    create_table :performances do |t|
      t.references :participant, foreign_key: true

      t.integer :baron_kills
      t.integer :dragon_kills
      t.integer :xp
      t.integer :objective_damage
      t.integer :turret_damage
      t.integer :objectives_stolen

      t.integer :largest_killing_spree
      t.integer :largest_critical_strike

      t.integer :physical_damage_dealt
      t.integer :physical_damage_taken
      t.integer :magic_damage_dealt
      t.integer :magic_damage_taken
      t.integer :true_damage_dealt
      t.integer :true_damage_taken
      t.integer :self_mitigated_damage
      t.integer :cc_score

      t.integer :control_wards_placed
      t.integer :stealth_wards_placed
      t.integer :wards_killed

      t.boolean :first_blood_assist
      t.boolean :first_blood_kill
      t.boolean :first_tower_assist
      t.boolean :first_tower_kill
      t.integer :inhibitor_kills
      t.integer :inhibitor_takedowns
      t.integer :turret_kills
      t.integer :turret_takedowns

      t.integer :gold_spent
      t.integer :q_casts
      t.integer :w_casts
      t.integer :e_casts
      t.integer :r_casts
      t.integer :summoner_spell_1_casts
      t.integer :summoner_spell_2_casts

      t.timestamps
    end
  end
end
