class AddEndedByToMatches < ActiveRecord::Migration[7.0]
  def change
    add_column :matches, :ended_by, :integer
  end
end
