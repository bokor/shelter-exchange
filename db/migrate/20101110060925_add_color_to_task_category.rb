class AddColorToTaskCategory < ActiveRecord::Migration
  def self.up
    add_column :task_categories, :color, :string
  end

  def self.down
    remove_column :task_categories, :color
  end
end
