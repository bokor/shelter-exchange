class DbIndexCleanup < ActiveRecord::Migration
  def change
    remove_index :animals, [:shelter_id, :updated_at]
    remove_index :animals, [:shelter_id, :created_at]
    add_index :animals, :created_at
    add_index :animals, :updated_at

    remove_index :tasks, :name => "tasks_by_shelter_id_and_tasksable"
    remove_index :tasks, :name => "tasks_by_taskable"

    add_index :tasks, [:shelter_id, :taskable_type]
    add_index :tasks, [:taskable_id, :taskable_type]

    add_index :alerts, [:shelter_id, :alertable_type]
    add_index :alerts, [:alertable_id, :alertable_type]

    add_index :comments, [:shelter_id, :commentable_type]
    add_index :comments, [:commentable_id, :commentable_type]

    remove_index :tasks, :name => "tasks_by_shelter_id"
  end
end
