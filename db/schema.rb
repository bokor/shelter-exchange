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

ActiveRecord::Schema.define(:version => 20110219171027) do

  create_table "accommodations", :force => true do |t|
    t.integer  "shelter_id"
    t.integer  "animal_type_id"
    t.string   "name"
    t.integer  "max_capacity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "location_id"
  end

  add_index "accommodations", ["animal_type_id"], :name => "index_accommodations_on_animal_type_id"
  add_index "accommodations", ["location_id"], :name => "index_accommodations_on_location_id"
  add_index "accommodations", ["name"], :name => "index_accommodations_on_name"
  add_index "accommodations", ["shelter_id"], :name => "index_accommodations_on_shelter_id"

  create_table "accounts", :force => true do |t|
    t.string   "subdomain"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accounts", ["subdomain"], :name => "index_accounts_on_subdomain"

  create_table "alerts", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "alertable_id"
    t.string   "alertable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_broadcast",   :default => false
    t.boolean  "is_stopped",     :default => false, :null => false
    t.integer  "shelter_id"
    t.string   "severity"
  end

  add_index "alerts", ["alertable_id", "alertable_type"], :name => "index_alerts_on_alertable_id_and_alertable_type"
  add_index "alerts", ["alertable_id"], :name => "index_alerts_on_alertable_id"
  add_index "alerts", ["alertable_type"], :name => "index_alerts_on_alertable_type"
  add_index "alerts", ["created_at"], :name => "index_alerts_on_created_at"
  add_index "alerts", ["description"], :name => "index_alerts_on_description"
  add_index "alerts", ["shelter_id"], :name => "index_alerts_on_shelter_id"
  add_index "alerts", ["title"], :name => "index_alerts_on_title"

  create_table "animal_statuses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "animal_statuses", ["created_at"], :name => "index_animal_statuses_on_created_at"
  add_index "animal_statuses", ["name"], :name => "index_animal_statuses_on_name"

  create_table "animal_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "animal_types", ["created_at"], :name => "index_animal_types_on_created_at"
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
    t.date     "status_change_date"
    t.date     "arrival_date"
    t.integer  "hold_time"
    t.date     "euthanasia_scheduled"
    t.integer  "accommodation_id"
  end

  add_index "animals", ["accommodation_id"], :name => "index_animals_on_accommodation_id"
  add_index "animals", ["animal_status_id"], :name => "index_animals_on_animal_status_id"
  add_index "animals", ["animal_type_id", "animal_status_id", "id", "name"], :name => "search_by_name"
  add_index "animals", ["animal_type_id", "animal_status_id", "name"], :name => "auto_complete"
  add_index "animals", ["animal_type_id"], :name => "index_animals_on_animal_type_id"
  add_index "animals", ["created_at"], :name => "index_animals_on_created_at"
  add_index "animals", ["description"], :name => "index_animals_on_description"
  add_index "animals", ["id", "name"], :name => "index_animals_on_id_and_name"
  add_index "animals", ["name"], :name => "index_animals_on_name"
  add_index "animals", ["shelter_id"], :name => "index_animals_on_shelter_id"
  add_index "animals", ["status_change_date"], :name => "index_animals_on_status_change_date"

  create_table "breeds", :force => true do |t|
    t.string   "name"
    t.integer  "animal_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "breeds", ["animal_type_id", "name"], :name => "index_breeds_on_animal_type_id_and_name"
  add_index "breeds", ["animal_type_id"], :name => "index_breeds_on_animal_type_id"
  add_index "breeds", ["created_at"], :name => "index_breeds_on_created_at"
  add_index "breeds", ["name"], :name => "index_breeds_on_name"

  create_table "capacities", :force => true do |t|
    t.integer  "shelter_id"
    t.integer  "animal_type_id"
    t.integer  "max_capacity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "capacities", ["animal_type_id"], :name => "index_capacities_on_animal_type_id"
  add_index "capacities", ["shelter_id", "animal_type_id"], :name => "index_capacities_on_shelter_id_and_animal_type_id"
  add_index "capacities", ["shelter_id"], :name => "index_capacities_on_shelter_id"

  create_table "comments", :force => true do |t|
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "shelter_id"
  end

  add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"
  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["commentable_type"], :name => "index_comments_on_commentable_type"
  add_index "comments", ["created_at"], :name => "index_comments_on_created_at"
  add_index "comments", ["shelter_id"], :name => "index_comments_on_shelter_id"

  create_table "items", :force => true do |t|
    t.integer  "shelter_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "items", ["shelter_id"], :name => "index_items_on_shelter_id"

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.integer  "shelter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "locations", ["name"], :name => "index_locations_on_name"
  add_index "locations", ["shelter_id"], :name => "index_locations_on_shelter_id"

  create_table "note_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "note_categories", ["created_at"], :name => "index_note_categories_on_created_at"
  add_index "note_categories", ["name"], :name => "index_note_categories_on_name"

  create_table "notes", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "notable_id"
    t.string   "notable_type"
    t.integer  "note_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "shelter_id"
  end

  add_index "notes", ["created_at"], :name => "index_notes_on_created_at"
  add_index "notes", ["description"], :name => "index_notes_on_description"
  add_index "notes", ["notable_id", "notable_type"], :name => "index_notes_on_notable_id_and_notable_type"
  add_index "notes", ["notable_id"], :name => "index_notes_on_notable_id"
  add_index "notes", ["notable_type"], :name => "index_notes_on_notable_type"
  add_index "notes", ["note_category_id"], :name => "index_notes_on_note_category_id"
  add_index "notes", ["shelter_id"], :name => "index_notes_on_shelter_id"
  add_index "notes", ["title"], :name => "index_notes_on_title"

  create_table "parents", :force => true do |t|
    t.string   "name"
    t.text     "street"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.string   "home_phone"
    t.string   "mobile_phone"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "parents", ["created_at"], :name => "index_parents_on_created_at"
  add_index "parents", ["name", "street", "home_phone", "mobile_phone", "email"], :name => "full_search"

  create_table "placements", :force => true do |t|
    t.integer  "animal_id"
    t.integer  "parent_id"
    t.integer  "shelter_id"
    t.string   "placement_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "placements", ["animal_id"], :name => "index_placements_on_animal_id"
  add_index "placements", ["parent_id", "placement_type"], :name => "index_placements_on_parent_id_and_placement_type"
  add_index "placements", ["parent_id", "shelter_id", "animal_id"], :name => "index_placements_on_parent_id_and_shelter_id_and_animal_id"
  add_index "placements", ["parent_id"], :name => "index_placements_on_parent_id"
  add_index "placements", ["shelter_id"], :name => "index_placements_on_shelter_id"

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
    t.boolean  "is_kill_shelter",   :default => false, :null => false
    t.decimal  "lat"
    t.decimal  "lng"
    t.string   "email"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "facebook"
    t.string   "time_zone"
  end

  add_index "shelters", ["account_id"], :name => "index_shelters_on_account_id"
  add_index "shelters", ["lat", "lng"], :name => "index_shelters_on_lat_and_lng"

  create_table "task_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "color"
  end

  add_index "task_categories", ["created_at"], :name => "index_task_categories_on_created_at"
  add_index "task_categories", ["name"], :name => "index_task_categories_on_name"

  create_table "tasks", :force => true do |t|
    t.string   "details"
    t.string   "due_at"
    t.date     "due_date"
    t.integer  "taskable_id"
    t.string   "taskable_type"
    t.integer  "task_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "due_category"
    t.boolean  "is_completed",     :default => false, :null => false
    t.integer  "shelter_id"
  end

  add_index "tasks", ["created_at"], :name => "index_tasks_on_created_at"
  add_index "tasks", ["details"], :name => "index_tasks_on_info"
  add_index "tasks", ["shelter_id"], :name => "index_tasks_on_shelter_id"
  add_index "tasks", ["task_category_id"], :name => "index_tasks_on_task_category_id"
  add_index "tasks", ["taskable_id", "taskable_type"], :name => "index_tasks_on_taskable_id_and_taskable_type"
  add_index "tasks", ["taskable_id"], :name => "index_tasks_on_taskable_id"
  add_index "tasks", ["taskable_type"], :name => "index_tasks_on_taskable_type"
  add_index "tasks", ["updated_at", "due_date"], :name => "index_tasks_on_updated_at_and_due_date"
  add_index "tasks", ["updated_at"], :name => "index_tasks_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => ""
    t.string   "password_salt",                       :default => ""
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "invitation_token",     :limit => 20
    t.datetime "invitation_sent_at"
    t.string   "role"
    t.integer  "failed_attempts",                     :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
  end

  add_index "users", ["account_id"], :name => "index_users_on_account_id"
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
