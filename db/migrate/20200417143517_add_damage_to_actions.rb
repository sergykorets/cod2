class AddDamageToActions < ActiveRecord::Migration[5.1]
  def change
    add_column :actions, :damage, :integer
    add_column :actions, :round_id, :integer
  end
end
