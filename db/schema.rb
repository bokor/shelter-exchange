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

ActiveRecord::Schema.define(:version => 20101104024509) do

  create_table "alert_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "alerts", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "subject_id"
    t.string   "subject_type"
    t.integer  "alert_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_broadcast"
  end

  add_index "alerts", ["description"], :name => "index_alerts_on_description"
  add_index "alerts", ["subject_id"], :name => "index_alerts_on_subject_id"
  add_index "alerts", ["title"], :name => "index_alerts_on_title"

  create_table "animal_statuses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "animal_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "notes", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "subject_id"
    t.string   "subject_type"
    t.integer  "note_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notes", ["description"], :name => "index_notes_on_description"
  add_index "notes", ["note_category_id"], :name => "index_notes_on_note_category_id"
  add_index "notes", ["subject_id"], :name => "index_notes_on_subject_id"
  add_index "notes", ["subject_type"], :name => "index_notes_on_subject_type"
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
  end

  create_table "task_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", :force => true do |t|
    t.string   "info"
    t.string   "due_at"
    t.date     "due_date"
    t.integer  "subject_id"
    t.string   "subject_type"
    t.integer  "task_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tasks", ["info"], :name => "index_tasks_on_info"
  add_index "tasks", ["subject_id"], :name => "index_tasks_on_subject_id"
  add_index "tasks", ["task_category_id"], :name => "index_tasks_on_task_category_id"

end
