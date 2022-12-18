class RenameTeamIdToSide < ActiveRecord::Migration[7.0]
  def change
    rename_column :teams, :team_id, :side
  end
end
