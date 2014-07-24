class ChangeMemoryFromStringToText < ActiveRecord::Migration
  def change
    change_column :memories, :memory, :text, :limit => 500
  end
end
