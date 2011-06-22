class RemoveTaskCategories < ActiveRecord::Migration
  def self.up
    rename_column :tasks, :task_category_id, :category
    change_column :tasks, :category, :string
    drop_table :task_categories
  end

  def self.down
  end
end
