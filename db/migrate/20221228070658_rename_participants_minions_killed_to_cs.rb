class RenameParticipantsMinionsKilledToCs < ActiveRecord::Migration[7.0]
  def change
    rename_column :participants, :minions_killed, :cs
  end
end
