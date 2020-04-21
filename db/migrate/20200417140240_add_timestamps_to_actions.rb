class AddTimestampsToActions < ActiveRecord::Migration[5.1]
  def change
    add_column :actions, :time_string, :string, null: false
    add_column :actions, :created_at, :datetime, null: false
    add_column :actions, :updated_at, :datetime, null: false
  end
end
