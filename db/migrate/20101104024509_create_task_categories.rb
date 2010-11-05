class CreateTaskCategories < ActiveRecord::Migration
  def self.up
    create_table :task_categories do |t|
      t.string :name
      
      t.timestamps
    end
    add_index(:task_categories, :name)
  end

  def self.down
    drop_table :task_categories
    remove_index :task_categories, :column => :name
  end
end
