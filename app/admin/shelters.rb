ActiveAdmin.register Shelter do
  
  # menu :parent => "Test"

  # Scopes
  #----------------------------------------------------------------------------  
  scope :all, :default => true do |shelters|
    shelters.unscoped.order("created_at ASC")
  end
  
  scope :kill do |shelters|
    shelters.unscoped.where(:is_kill_shelter => true).order("created_at ASC")
  end
  
  scope :no_kill do |shelters|
    shelters.unscoped.where(:is_kill_shelter => false).order("created_at ASC")
  end

  # Filters
  #----------------------------------------------------------------------------  
  filter :name
  filter :street
  filter :city
  filter :state, :as => :select, :collection => proc { US_STATES.map {|k,v| [ v, k ] } }
  filter :zip_code
  filter :is_kill_shelter, :as => :check_boxes
  
  # Index
  #----------------------------------------------------------------------------  
  index do    
    column("Logo") { |shelter| link_to image_tag(shelter.logo.url(:thumb)), admin_shelter_path(shelter) }
    column("Name") { |shelter| link_to shelter.name, admin_shelter_path(shelter) }
    column("Address") { |shelter| [shelter.street, shelter.street_2, shelter.city, shelter.state, shelter.zip_code].join(" ").html_safe }
    column :website, :sortable => false
    column :email, :sortable => false
    # column("Kill/No Kill") { |shelter| shelter.is_kill_shelter ? "Kill" : "No Kill" }
  end

  # Show
  #----------------------------------------------------------------------------  
  show do
    
  end
  
  # Form
  #----------------------------------------------------------------------------
  form do |f|
  end
  
end


# index :as => :grid do |shelter|
#     link_to(image_tag(shelter.logo.url(:thumb)), admin_shelter_path(shelter))
#   end


# t.string   "website"
# t.string   "phone"
# t.string   "fax"
# t.string   "twitter"
# t.string   "facebook"
# 
# t.datetime "created_at"
# t.datetime "updated_at"
# t.integer  "account_id"
# 
# t.decimal  "lat",               :precision => 15, :scale => 10
# t.decimal  "lng",               :precision => 15, :scale => 10
# 
# t.string   "email"
# 
# t.string   "time_zone"
# t.string   "access_token"
