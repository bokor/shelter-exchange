class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.string :info
      t.string :due_at
      t.date :due_date
      t.references :subject, :polymorphic => true 
      t.references :task_category 

      t.timestamps
    end
    add_index(:tasks, :subject_id)
    add_index(:tasks, :task_category_id)
    add_index(:tasks, :info)
  end

  def self.down
    drop_table :tasks
    remove_index :tasks, :column => :subject_id
    remove_index :tasks, :column => :task_category_id
    remove_index :tasks, :column => :info
  end
end
  