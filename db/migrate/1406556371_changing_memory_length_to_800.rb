class ChangingMemoryLengthTo800 < ActiveRecord::Migration
  def change
    change_column :memories, :memory, :text, :limit => 800
  end
end
