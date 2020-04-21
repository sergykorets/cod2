class CreateSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :settings do |t|
      t.integer :last_line
    end
  end
end
