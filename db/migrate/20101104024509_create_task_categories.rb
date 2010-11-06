class CreateTaskCategories < ActiveRecord::Migration
  def self.up
    create_table :task_categories do |t|
      t.string :name
      
      t.timestamps
    end
    add_index(:task_categories, :name)
    add_index(:task_categories, :created_at)
  end

  def self.down
    drop_table :task_categories
    remove_index :task_categories, :column => :name
    remove_index :task_categories, :column => :created_at
  end
end
