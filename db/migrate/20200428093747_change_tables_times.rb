class ChangeTablesTimes < ActiveRecord::Migration[5.1]
  def change
    remove_column :actions, :time_string, :string
    remove_column :rounds, :time_string_start, :string
    remove_column :rounds, :time_string_end, :string
    add_column :actions,:time, :integer
    add_column :rounds, :time_start, :integer
    add_column :rounds, :time_end, :integer
    add_column :nicknames, :created_at, :datetime
    add_column :nicknames, :updated_at, :datetime
  end
end
