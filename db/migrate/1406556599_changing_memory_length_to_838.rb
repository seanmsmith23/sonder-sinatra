class ChangingMemoryLengthTo838 < ActiveRecord::Migration
  def change
    change_column :memories, :memory, :text, :limit => 838
  end
end
