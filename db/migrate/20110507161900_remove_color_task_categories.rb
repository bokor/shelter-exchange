class RemoveColorTaskCategories < ActiveRecord::Migration
  def self.up
    remove_column :task_categories, :color
  end

  def self.down
  end
end
