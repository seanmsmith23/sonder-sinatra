class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :email
      t.string :password
    end
    add_index :users, :email, unique: true

    create_table :memorials do |t|
      t.string :name
      t.string :born
      t.string :died
      t.integer :creator_id
    end

    create_table :users_memorials do |t|
      t.integer :user_id
      t.integer :memorial_id
    end

    create_table :memories do |t|
      t.integer :user_id
      t.integer :memorial_id
      t.string :memory
    end
  end

  def down
    drop_table :users
    drop_table :memorials
    drop_table :users_memorials
    drop_table :memories
  end
end
