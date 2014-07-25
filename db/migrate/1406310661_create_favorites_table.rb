class CreateFavoritesTable < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.integer :memory_id
      t.integer :user_id
    end
  end
end
