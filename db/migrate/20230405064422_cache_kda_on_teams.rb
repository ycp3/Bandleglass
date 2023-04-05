class CacheKdaOnTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :kills, :integer
    add_column :teams, :deaths, :integer
    add_column :teams, :assists, :integer
  end
end
