class CreateChampions < ActiveRecord::Migration[7.0]
  def change
    create_table :champions do |t|
      t.string :name
      t.string :title
      t.string :internal_name
      t.text :lore
      t.string :tags, array: true, default: []

      t.timestamps
    end
  end
end
