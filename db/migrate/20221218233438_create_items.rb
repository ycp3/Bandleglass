class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :name
      t.text :description
      t.integer :cost
      t.integer :sell_value

      t.timestamps
    end
  end
end
