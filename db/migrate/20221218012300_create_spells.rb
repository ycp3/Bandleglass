class CreateSpells < ActiveRecord::Migration[7.0]
  def change
    create_table :spells do |t|
      t.references :champion, foreign_key: true
      t.integer :spell_type
      t.string :name
      t.string :internal_name
      t.text :description

      t.timestamps
    end
    add_index :spells, [:champion_id, :spell_type], unique: true
  end
end
