class AddNameToPhotos < ActiveRecord::Migration[5.1]
  def change
    add_column :photos, :name, :string
  end
end
