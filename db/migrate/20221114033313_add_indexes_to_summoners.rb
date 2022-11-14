class AddIndexesToSummoners < ActiveRecord::Migration[7.0]
  def change
    add_index :summoners, [:name, :region], unique: true
    add_index :summoners, :puuid, unique: true
  end
end
