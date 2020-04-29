class AddStatsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :stats, :jsonb
  end
end
