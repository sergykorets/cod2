class AddCategoryIdToCars < ActiveRecord::Migration[5.1]
  def change
    add_column :cars, :category_id, :integer
  end
end
