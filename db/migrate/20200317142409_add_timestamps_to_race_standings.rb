class AddTimestampsToRaceStandings < ActiveRecord::Migration[5.1]
  def change
    add_column :race_standings, :created_at, :datetime
    add_column :race_standings, :updated_at, :datetime
  end
end
