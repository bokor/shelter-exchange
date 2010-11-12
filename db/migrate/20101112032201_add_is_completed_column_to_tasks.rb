class AddIsCompletedColumnToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :is_completed, :boolean, {:default=>false, :null=>false}
  end

  def self.down
    remove_column :tasks, :is_completed
  end
end
