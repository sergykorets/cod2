class CreateCoupons < ActiveRecord::Migration[5.1]
  def change
    create_table :coupons do |t|
      t.integer :number
      t.string :name
      t.string :image
    end
  end
end
