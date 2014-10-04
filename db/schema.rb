# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20141004232658) do

  create_table "accommodations", :force => true do |t|
    t.integer  "shelter_id"
    t.integer  "animal_type_id"
    t.string   "name"
    t.integer  "max_capacity"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "location_id"
  end

  add_index "accommodations", ["animal_type_id"], :name => "index_accommodations_on_animal_type_id"
  add_index "accommodations", ["location_id"], :name => "index_accommodations_on_location_id"
  add_index "accommodations", ["name"], :name => "index_accommodations_on_name"
  add_index "accommodations", ["shelter_id"], :name => "index_accommodations_on_shelter_id"

  create_table "accounts", :force => true do |t|
    t.string   "subdomain"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "document"
    t.string   "document_type"
  end

  add_index "accounts", ["subdomain"], :name => "index_accounts_on_subdomain"

  create_table "alerts", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "alertable_id"
    t.string   "alertable_type"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.boolean  "stopped",        :default => false, :null => false
    t.integer  "shelter_id"
    t.string   "severity"
  end

  add_index "alerts", ["alertable_id", "alertable_type"], :name => "index_alerts_on_alertable_id_and_alertable_type"
  add_index "alerts", ["alertable_id"], :name => "index_alerts_on_alertable_id"
  add_index "alerts", ["alertable_type"], :name => "index_alerts_on_alertable_type"
  add_index "alerts", ["created_at"], :name => "index_alerts_on_created_at"
  add_index "alerts", ["shelter_id", "alertable_type"], :name => "index_alerts_on_shelter_id_and_alertable_type"
  add_index "alerts", ["shelter_id"], :name => "index_alerts_on_shelter_id"
  add_index "alerts", ["title"], :name => "index_alerts_on_title"

  create_table "animal_statuses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "sort_order"
  end

  add_index "animal_statuses", ["created_at"], :name => "index_animal_statuses_on_created_at"
  add_index "animal_statuses", ["name"], :name => "index_animal_statuses_on_name"
  add_index "animal_statuses", ["sort_order"], :name => "index_animal_statuses_on_sort_order"

  create_table "animal_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "animal_types", ["created_at"], :name => "index_animal_types_on_created_at"
  add_index "animal_types", ["name"], :name => "index_animal_types_on_name"

  create_table "animals", :force => true do |t|
    t.string   "microchip"
    t.string   "name"
    t.text     "description"
    t.string   "sex"
    t.string   "weight"
    t.date     "date_of_birth"
    t.boolean  "is_sterilized"
    t.string   "color"
    t.boolean  "is_mix_breed"
    t.string   "primary_breed"
    t.string   "secondary_breed"
    t.integer  "animal_type_id"
    t.integer  "animal_status_id"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.integer  "shelter_id"
    t.date     "status_change_date"
    t.date     "arrival_date"
    t.integer  "hold_time"
    t.date     "euthanasia_date"
    t.integer  "accommodation_id"
    t.string   "size"
    t.boolean  "has_special_needs",  :default => false, :null => false
    t.text     "special_needs"
    t.string   "video_url"
    t.string   "age"
  end

  add_index "animals", ["accommodation_id"], :name => "index_animals_on_accommodation_id"
  add_index "animals", ["animal_status_id"], :name => "index_animals_on_animal_status_id"
  add_index "animals", ["animal_type_id", "animal_status_id", "id", "name"], :name => "search_by_name"
  add_index "animals", ["animal_type_id", "animal_status_id", "name"], :name => "auto_complete"
  add_index "animals", ["animal_type_id"], :name => "index_animals_on_animal_type_id"
  add_index "animals", ["created_at", "shelter_id"], :name => "index_animals_on_created_at_and_shelter_id"
  add_index "animals", ["created_at"], :name => "index_animals_on_created_at"
  add_index "animals", ["id", "name"], :name => "index_animals_on_id_and_name"
  add_index "animals", ["name"], :name => "index_animals_on_name"
  add_index "animals", ["shelter_id"], :name => "index_animals_on_shelter_id"
  add_index "animals", ["status_change_date"], :name => "index_animals_on_status_change_date"
  add_index "animals", ["updated_at"], :name => "index_animals_on_updated_at"

  create_table "announcements", :force => true do |t|
    t.string   "title"
    t.text     "message"
    t.string   "category"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "announcements", ["starts_at", "ends_at", "updated_at"], :name => "index_announcements_on_starts_at_and_ends_at_and_updated_at"
  add_index "announcements", ["starts_at", "ends_at"], :name => "index_announcements_on_starts_at_and_ends_at"
  add_index "announcements", ["starts_at", "updated_at"], :name => "index_announcements_on_starts_at_and_updated_at"

  create_table "breeds", :force => true do |t|
    t.string   "name"
    t.integer  "animal_type_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "breeds", ["animal_type_id", "name"], :name => "index_breeds_on_animal_type_id_and_name"
  add_index "breeds", ["animal_type_id"], :name => "index_breeds_on_animal_type_id"
  add_index "breeds", ["created_at"], :name => "index_breeds_on_created_at"
  add_index "breeds", ["name"], :name => "index_breeds_on_name"

  create_table "capacities", :force => true do |t|
    t.integer  "shelter_id"
    t.integer  "animal_type_id"
    t.integer  "max_capacity"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "capacities", ["animal_type_id"], :name => "index_capacities_on_animal_type_id"
  add_index "capacities", ["shelter_id", "animal_type_id"], :name => "index_capacities_on_shelter_id_and_animal_type_id"
  add_index "capacities", ["shelter_id"], :name => "index_capacities_on_shelter_id"

  create_table "comments", :force => true do |t|
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "shelter_id"
  end

  add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"
  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["commentable_type"], :name => "index_comments_on_commentable_type"
  add_index "comments", ["created_at"], :name => "index_comments_on_created_at"
  add_index "comments", ["shelter_id", "commentable_type"], :name => "index_comments_on_shelter_id_and_commentable_type"
  add_index "comments", ["shelter_id"], :name => "index_comments_on_shelter_id"

  create_table "contacts", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "street"
    t.string   "street_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.string   "phone"
    t.string   "mobile"
    t.string   "email"
    t.boolean  "adopter",                                      :default => false
    t.boolean  "foster",                                       :default => false
    t.boolean  "volunteer",                                    :default => false
    t.boolean  "transporter",                                  :default => false
    t.boolean  "donor",                                        :default => false
    t.boolean  "staff",                                        :default => false
    t.boolean  "veterinarian",                                 :default => false
    t.integer  "shelter_id"
    t.datetime "created_at",                                                      :null => false
    t.datetime "updated_at",                                                      :null => false
    t.decimal  "lat",          :precision => 15, :scale => 10
    t.decimal  "lng",          :precision => 15, :scale => 10
    t.string   "photo"
    t.string   "company_name"
    t.string   "job_title"
  end

  add_index "contacts", ["adopter"], :name => "index_contacts_on_adopter"
  add_index "contacts", ["donor"], :name => "index_contacts_on_donor"
  add_index "contacts", ["email"], :name => "index_contacts_on_email"
  add_index "contacts", ["first_name"], :name => "index_contacts_on_first_name"
  add_index "contacts", ["foster"], :name => "index_contacts_on_foster"
  add_index "contacts", ["last_name", "first_name", "company_name"], :name => "index_contacts_on_last_name_and_first_name_and_company_name"
  add_index "contacts", ["last_name", "first_name"], :name => "index_contacts_on_last_name_and_first_name"
  add_index "contacts", ["last_name"], :name => "index_contacts_on_last_name"
  add_index "contacts", ["lat", "lng"], :name => "index_contacts_on_lat_and_lng"
  add_index "contacts", ["phone", "mobile"], :name => "index_contacts_on_phone_and_mobile"
  add_index "contacts", ["shelter_id"], :name => "index_contacts_on_shelter_id"
  add_index "contacts", ["staff"], :name => "index_contacts_on_staff"
  add_index "contacts", ["transporter"], :name => "index_contacts_on_transporter"
  add_index "contacts", ["veterinarian"], :name => "index_contacts_on_veterinarian"
  add_index "contacts", ["volunteer"], :name => "index_contacts_on_volunteer"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.string   "queue"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "documents", :force => true do |t|
    t.string   "document"
    t.string   "original_name"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "documents", ["attachable_id", "attachable_type"], :name => "index_documents_on_attachable_id_and_attachable_type"
  add_index "documents", ["attachable_id"], :name => "index_documents_on_attachable_id"
  add_index "documents", ["attachable_type"], :name => "index_documents_on_attachable_type"

  create_table "integrations", :force => true do |t|
    t.string   "type"
    t.string   "username"
    t.string   "password"
    t.integer  "shelter_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "integrations", ["id", "type"], :name => "index_integrations_on_id_and_type"
  add_index "integrations", ["shelter_id", "type"], :name => "index_integrations_on_shelter_id_and_type"
  add_index "integrations", ["shelter_id"], :name => "index_integrations_on_shelter_id"
  add_index "integrations", ["type"], :name => "index_integrations_on_type"

  create_table "items", :force => true do |t|
    t.integer  "shelter_id"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "items", ["shelter_id"], :name => "index_items_on_shelter_id"

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.integer  "shelter_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "locations", ["name"], :name => "index_locations_on_name"
  add_index "locations", ["shelter_id"], :name => "index_locations_on_shelter_id"

  create_table "notes", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "notable_id"
    t.string   "notable_type"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.integer  "shelter_id"
    t.string   "category"
    t.boolean  "hidden",       :default => false
  end

  add_index "notes", ["created_at"], :name => "index_notes_on_created_at"
  add_index "notes", ["hidden"], :name => "index_notes_on_hidden"
  add_index "notes", ["notable_id", "notable_type"], :name => "index_notes_on_notable_id_and_notable_type"
  add_index "notes", ["notable_id"], :name => "index_notes_on_notable_id"
  add_index "notes", ["notable_type"], :name => "index_notes_on_notable_type"
  add_index "notes", ["shelter_id"], :name => "index_notes_on_shelter_id"
  add_index "notes", ["title"], :name => "index_notes_on_title"

  create_table "owners", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.string   "role"
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",        :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "owners", ["authentication_token"], :name => "index_owners_on_authentication_token", :unique => true
  add_index "owners", ["confirmation_token"], :name => "index_owners_on_confirmation_token", :unique => true
  add_index "owners", ["email"], :name => "index_owners_on_email", :unique => true
  add_index "owners", ["reset_password_token"], :name => "index_owners_on_reset_password_token", :unique => true
  add_index "owners", ["unlock_token"], :name => "index_owners_on_unlock_token", :unique => true

  create_table "photos", :force => true do |t|
    t.string   "image"
    t.boolean  "is_main_photo",   :default => false
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "original_name"
  end

  add_index "photos", ["attachable_id", "attachable_type", "is_main_photo"], :name => "attachable_main_photo"
  add_index "photos", ["attachable_id", "attachable_type"], :name => "index_photos_on_attachable_id_and_attachable_type"
  add_index "photos", ["attachable_id", "is_main_photo", "created_at"], :name => "attachable_main_photo_created_at"
  add_index "photos", ["attachable_id", "is_main_photo"], :name => "index_photos_on_attachable_id_and_is_main_photo"
  add_index "photos", ["attachable_id"], :name => "index_photos_on_attachable_id"
  add_index "photos", ["attachable_type"], :name => "index_photos_on_attachable_type"

  create_table "shelters", :force => true do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "fax"
    t.string   "website"
    t.string   "twitter"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.datetime "created_at",                                                            :null => false
    t.datetime "updated_at",                                                            :null => false
    t.integer  "account_id"
    t.boolean  "is_kill_shelter",                                 :default => false,    :null => false
    t.decimal  "lat",             :precision => 15, :scale => 10
    t.decimal  "lng",             :precision => 15, :scale => 10
    t.string   "email"
    t.string   "logo"
    t.string   "facebook"
    t.string   "time_zone"
    t.string   "access_token"
    t.string   "street_2"
    t.string   "status",                                          :default => "active"
    t.text     "status_reason"
  end

  add_index "shelters", ["access_token"], :name => "index_shelters_on_access_token", :unique => true
  add_index "shelters", ["account_id"], :name => "index_shelters_on_account_id"
  add_index "shelters", ["id", "status", "is_kill_shelter"], :name => "index_shelters_on_id_and_status_and_is_kill_shelter"
  add_index "shelters", ["id", "status"], :name => "index_shelters_on_id_and_status"
  add_index "shelters", ["lat", "lng"], :name => "index_shelters_on_lat_and_lng"
  add_index "shelters", ["status", "lat", "lng"], :name => "index_shelters_on_status_and_lat_and_lng"

  create_table "status_histories", :force => true do |t|
    t.integer  "shelter_id"
    t.integer  "animal_id"
    t.integer  "animal_status_id"
    t.string   "reason"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.date     "status_date"
    t.integer  "contact_id"
  end

  add_index "status_histories", ["animal_id"], :name => "index_status_histories_on_animal_id"
  add_index "status_histories", ["animal_status_id"], :name => "index_status_histories_on_animal_status_id"
  add_index "status_histories", ["contact_id", "animal_status_id"], :name => "index_status_histories_on_contact_id_and_animal_status_id"
  add_index "status_histories", ["contact_id"], :name => "index_status_histories_on_contact_id"
  add_index "status_histories", ["created_at", "animal_id"], :name => "index_status_histories_on_created_at_and_animal_id"
  add_index "status_histories", ["shelter_id"], :name => "index_status_histories_on_shelter_id"
  add_index "status_histories", ["status_date", "created_at"], :name => "index_status_histories_on_status_date_and_created_at"
  add_index "status_histories", ["status_date"], :name => "index_status_histories_on_status_date"

  create_table "tasks", :force => true do |t|
    t.string   "details"
    t.string   "due_at"
    t.date     "due_date"
    t.integer  "taskable_id"
    t.string   "taskable_type"
    t.string   "category"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "due_category"
    t.boolean  "completed",     :default => false, :null => false
    t.integer  "shelter_id"
  end

  add_index "tasks", ["created_at"], :name => "index_tasks_on_created_at"
  add_index "tasks", ["shelter_id", "taskable_type"], :name => "index_tasks_on_shelter_id_and_taskable_type"
  add_index "tasks", ["shelter_id"], :name => "index_tasks_on_shelter_id"
  add_index "tasks", ["taskable_id", "taskable_type"], :name => "index_tasks_on_taskable_id_and_taskable_type"
  add_index "tasks", ["taskable_id"], :name => "index_tasks_on_taskable_id"
  add_index "tasks", ["taskable_type"], :name => "index_tasks_on_taskable_type"
  add_index "tasks", ["updated_at", "due_date"], :name => "index_tasks_on_updated_at_and_due_date"
  add_index "tasks", ["updated_at"], :name => "index_tasks_on_updated_at"

  create_table "transfer_histories", :force => true do |t|
    t.integer  "shelter_id"
    t.integer  "transfer_id"
    t.string   "status"
    t.text     "reason"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "transfer_histories", ["shelter_id"], :name => "index_transfer_histories_on_shelter_id"
  add_index "transfer_histories", ["transfer_id"], :name => "index_transfer_histories_on_transfer_id"

  create_table "transfers", :force => true do |t|
    t.integer  "animal_id"
    t.integer  "requestor_shelter_id"
    t.string   "requestor"
    t.string   "phone"
    t.string   "email"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "shelter_id"
    t.string   "status"
  end

  add_index "transfers", ["animal_id"], :name => "index_transfers_on_animal_id"
  add_index "transfers", ["requestor_shelter_id"], :name => "index_transfers_on_to_shelter"
  add_index "transfers", ["shelter_id"], :name => "index_transfers_on_from_shelter"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.string   "role"
    t.integer  "account_id"
    t.string   "email",                                :default => "", :null => false
    t.string   "encrypted_password",                   :default => ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",                      :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.string   "invitation_token",       :limit => 60
    t.datetime "invitation_sent_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.datetime "announcement_hide_time"
    t.datetime "invitation_accepted_at"
  end

  add_index "users", ["account_id"], :name => "index_users_on_account_id"
  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token"
  add_index "users", ["invited_by_id"], :name => "index_users_on_invited_by_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

end
