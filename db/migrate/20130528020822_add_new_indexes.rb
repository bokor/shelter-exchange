class AddNewIndexes < ActiveRecord::Migration
  def change
    remove_index :tasks, :name => "index_tasks_on_task_category_id"
    remove_index :tasks, :name => "index_tasks_on_info"

    add_index :animals, :created_at
    add_index :animals, :updated_at

    add_index :integrations, [:shelter_id, :type]

    add_index :tasks, [:shelter_id, :taskable_type]
    add_index :alerts, [:shelter_id, :alertable_type]
    add_index :comments, [:shelter_id, :commentable_type]
  end
end
