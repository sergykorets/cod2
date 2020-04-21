class CreateActions < ActiveRecord::Migration[5.1]
  def change
    create_table :actions do |t|
      t.integer :action_type
      t.integer :damaged_user_id
      t.integer :damaging_user_id
      t.integer :weapon_id
      t.integer :action_damagetype
    end
  end
end
