class DbIndexAudit < ActiveRecord::Migration
  def change
    remove_index :accommodations, :name

    remove_index :alerts, [:alertable_id, :alertable_type]
    remove_index :alerts, :alertable_type
    remove_index :alerts, :created_at
    remove_index :alerts, :title

    remove_index :animal_statuses, :created_at
    remove_index :animal_statuses, :name

    remove_index :animal_types, :name

    remove_index :animals, :name => "search_by_name"
    remove_index :animals, :name => "auto_complete"
    remove_index :animals, [:created_at, :shelter_id]
    remove_index :animals, [:id, :name]
    remove_index :animals, :created_at
    remove_index :animals, :name
    remove_index :animals, :status_change_date

    remove_index :breeds, :created_at
    remove_index :breeds, :name

    remove_index :comments, [:commentable_id, :commentable_type]
    remove_index :comments, :commentable_type
    remove_index :comments, :created_at

    remove_index :integrations, [:id, :type]
    remove_index :integrations, :type

    remove_index :locations, :name

    remove_index :notes, :created_at
    remove_index :notes, :hidden
    remove_index :notes, [:notable_id, :notable_type]
    remove_index :notes, :notable_type
    remove_index :notes, :title

    remove_index :shelters, [:id, :status, :is_kill_shelter]
    remove_index :shelters, [:id, :status]
    remove_index :shelters, [:status, :lat, :lng]

    remove_index :status_histories, [:created_at, :animal_id]

    remove_index :tasks, :name => "index_tasks_on_task_category_id"
    remove_index :tasks, :created_at
    remove_index :tasks, :name => "index_tasks_on_info"
    remove_index :tasks, [:taskable_id, :taskable_type]
    remove_index :tasks, :taskable_type
    remove_index :tasks, :updated_at

    add_index :alerts, [:shelter_id, :alertable_type, :created_at], :name => "alerts_with_shelter_and_alertable"
    add_index :alerts, [:alertable_id, :alertable_type, :created_at], :name => "alerts_with_alertable"

    add_index :animals, [:shelter_id, :updated_at]
    add_index :animals, [:shelter_id, :created_at]

    add_index :comments, [:shelter_id, :commentable_type, :created_at], :name => "comments_with_shelter_and_commentable"
    add_index :comments, [:commentable_id, :commentable_type, :created_at], :name => "comments_with_commentable"

    add_index :integrations, [:shelter_id, :type]

    add_index :notes, [:notable_id, :created_at]

    add_index :status_histories, [:animal_id, :created_at], :name => "status_history_animal"

    add_index :tasks, [:shelter_id, :taskable_type, :due_date, :updated_at], :name => "tasks_by_shelter_id_and_tasksable"
    add_index :tasks, [:taskable_id, :taskable_type, :due_date, :updated_at], :name => "tasks_by_taskable"
    add_index :tasks, [:shelter_id, :due_date, :updated_at], :name => "tasks_by_shelter_id"
  end
end

