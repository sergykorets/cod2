class CreateNicknames < ActiveRecord::Migration[5.1]
  def change
    create_table :nicknames do |t|
      t.integer :user_id
      t.string :name
    end
  end
end
