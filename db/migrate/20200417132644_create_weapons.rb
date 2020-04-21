class CreateWeapons < ActiveRecord::Migration[5.1]
  def change
    create_table :weapons do |t|
      t.integer :weapon_type
      t.string :name
      t.attachment :image
    end
  end
end
