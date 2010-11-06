class AddDueCategoryToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :due_category, :string
  end

  def self.down
    remove_column :tasks, :due_category
  end
end
