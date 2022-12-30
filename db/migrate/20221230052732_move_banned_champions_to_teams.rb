class MoveBannedChampionsToTeams < ActiveRecord::Migration[7.0]
  def change
    remove_reference :participants, :ban
    add_column :teams, :banned_champion_ids, :integer, array: true, default: []
  end
end
