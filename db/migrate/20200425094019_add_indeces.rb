class AddIndeces < ActiveRecord::Migration[5.1]
  def change
    add_index :actions, :damaged_user_idra
    add_index :actions, :damaging_user_id
    add_index :actions, :weapon_id
    add_index :actions, :round_id
    add_index :nicknames, :user_id
  end
end
