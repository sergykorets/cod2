class CreateRounds < ActiveRecord::Migration[5.1]
  def change
    create_table :rounds do |t|
      t.string :time_string_start
      t.string :time_string_end
      t.string :location
      t.integer :round_type
      t.timestamps
    end
  end
end
