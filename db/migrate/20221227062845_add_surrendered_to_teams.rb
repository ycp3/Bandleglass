class AddSurrenderedToTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :surrendered, :boolean
  end
end
