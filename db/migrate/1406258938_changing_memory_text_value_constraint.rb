class ChangingMemoryTextValueConstraint < ActiveRecord::Migration
  def change
    change_column :memories, :memory, :text, :limit => 600
  end
end
