class AddPhotoToMemorials < ActiveRecord::Migration
  def up
    add_column :memorials, :photo, :string
  end

  def down
    remove_column :memorials, :photo
  end
end
