class ChangeIsCompletedTasks < ActiveRecord::Migration
  def self.up
    rename_column :tasks, :is_completed, :completed
  end

  def self.down
  end
end
