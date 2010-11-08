class RemoveDueDateAddDueAtColumnsTask < ActiveRecord::Migration
  def self.up
    # remove_column :tasks, :due_date
    # add_column :tasks, :due_at_date
    # add_column :tasks, :due_at_hour
    # add_column :tasks, :due_at_min
    # add_column :tasks, :due_at_ampm
  end

  def self.down
  end
end
