# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101114160119) do

  create_table "accounts", :force => true do |t|
    t.string   "subdomain"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
  end

  create_table "alert_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "alert_types", ["name"], :name => "index_alert_types_on_name"

  create_table "alerts", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "alertable_id"
    t.string   "alertable_type"
    t.integer  "alert_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_broadcast"
    t.boolean  "is_stopped",     :default => false
  end

  add_index "alerts", ["alertable_id", "alertable_type"], :name => "index_alerts_on_alertable_id_and_alertable_type"
  add_index "alerts", ["alertable_id"], :name => "index_alerts_on_alertable_id"
  add_index "alerts", ["alertable_type"], :name => "index_alerts_on_alertable_type"
  add_index "alerts", ["description"], :name => "index_alerts_on_description"
  add_index "alerts", ["title"], :name => "index_alerts_on_title"

  create_table "animal_statuses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "animal_statuses", ["name"], :name => "index_animal_statuses_on_name"

  create_table "animal_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "animal_types", ["name"], :name => "index_animal_types_on_name"

  create_table "animals", :force => true do |t|
    t.string   "chip_id"
    t.string   "name"
    t.text     "description"
    t.string   "sex"
    t.string   "weight"
    t.string   "age"
    t.boolean  "is_sterilized"
    t.string   "color"
    t.boolean  "is_mix_breed"
    t.string   "primary_breed"
    t.string   "secondary_breed"
    t.integer  "animal_type_id"
    t.integer  "animal_status_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "shelter_id"
  end

  add_index "animals", ["animal_status_id"], :name => "index_animals_on_animal_status_id"
  add_index "animals", ["animal_type_id"], :name => "index_animals_on_animal_type_id"
  add_index "animals", ["description"], :name => "index_animals_on_description"
  add_index "animals", ["name"], :name => "index_animals_on_name"
  add_index "animals", ["shelter_id"], :name => "index_animals_on_shelter_id"

  create_table "breeds", :force => true do |t|
    t.string   "name"
    t.integer  "animal_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "breeds", ["animal_type_id"], :name => "index_breeds_on_animal_type_id"
  add_index "breeds", ["name"], :name => "index_breeds_on_name"

  create_table "note_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "note_categories", ["name"], :name => "index_note_categories_on_name"

  create_table "notes", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "notable_id"
    t.string   "notable_type"
    t.integer  "note_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notes", ["description"], :name => "index_notes_on_description"
  add_index "notes", ["notable_id", "notable_type"], :name => "index_notes_on_notable_id_and_notable_type"
  add_index "notes", ["notable_id"], :name => "index_notes_on_notable_id"
  add_index "notes", ["notable_type"], :name => "index_notes_on_notable_type"
  add_index "notes", ["note_category_id"], :name => "index_notes_on_note_category_id"
  add_index "notes", ["title"], :name => "index_notes_on_title"

  create_table "shelters", :force => true do |t|
    t.string   "name"
    t.string   "main_phone"
    t.string   "fax_phone"
    t.string   "website"
    t.string   "twitter"
    t.text     "street"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
  end

  add_index "shelters", ["account_id"], :name => "index_shelters_on_account_id"

  create_table "task_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "color"
  end

  add_index "task_categories", ["name"], :name => "index_task_categories_on_name"

  create_table "tasks", :force => true do |t|
    t.string   "info"
    t.string   "due_at"
    t.date     "due_date"
    t.integer  "taskable_id"
    t.string   "taskable_type"
    t.integer  "task_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "due_category"
    t.boolean  "is_completed",     :default => false, :null => false
  end

  add_index "tasks", ["info"], :name => "index_tasks_on_info"
  add_index "tasks", ["task_category_id"], :name => "index_tasks_on_task_category_id"
  add_index "tasks", ["taskable_id", "taskable_type"], :name => "index_tasks_on_taskable_id_and_taskable_type"
  add_index "tasks", ["taskable_id"], :name => "index_tasks_on_taskable_id"
  add_index "tasks", ["taskable_type"], :name => "index_tasks_on_taskable_type"

  create_table "users", :force => true do |t|
    t.string   "email",                              :null => false
    t.string   "crypted_password",                   :null => false
    t.string   "password_salt",                      :null => false
    t.string   "persistence_token",                  :null => false
    t.string   "single_access_token",                :null => false
    t.string   "perishable_token",                   :null => false
    t.integer  "login_count",         :default => 0, :null => false
    t.integer  "failed_login_count",  :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "account_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token", :unique => true

end
