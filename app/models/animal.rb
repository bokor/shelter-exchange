class Animal < ActiveRecord::Base
  default_scope :order => 'created_at DESC'
  before_create :update_status_change_date
  before_save :check_status_change
  
  
  PER_PAGE = 5
  SEX = [ "Male", "Female" ]
  
  # Associations
  belongs_to :animal_type, :readonly => true
  belongs_to :animal_status, :readonly => true
  belongs_to :shelter
  
  has_many :placements, :dependent => :destroy
  # has_many :parents, :through => :placements
  # has_many :breeds, :readonly => true
  has_many :notes, :as => :notable, :dependent => :destroy
  has_many :alerts, :as => :alertable, :dependent => :destroy
  has_many :tasks, :as => :taskable, :dependent => :destroy
  
  has_attached_file :photo, :default_url => "/images/default_:style_photo.jpg", 
                            :styles => { :small => ["250x150>", :jpg],
                                         :medium => ["350x250>", :jpg],
                                         :large => ["500x400>", :jpg], 
                                         :thumb => ["100x75#", :jpg] } 

  # Validations
  validates_presence_of :name
  validates_presence_of :animal_type_id, :message => 'needs to be selected'
  validates_presence_of :animal_status_id, :message => 'needs to be selected'
  validate :primary_breed, :presence => true, :if => :primary_breed_exists
  validate :secondary_breed, :presence => true, :if => :secondary_breed_exists
  
  validates_attachment_size :photo, :less_than => 1.megabytes, :message => 'needs to be 1 MB or smaller'
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif'], :message => 'needs to be a JPG, PNG, or GIF file'


  
  
  # Scopes
  scope :auto_complete, lambda { |q| {:conditions => "LOWER(name) LIKE LOWER('%#{q}%')" }}
  scope :live_search, lambda { |q| { :conditions => "LOWER(id) LIKE LOWER('%#{q}%') OR LOWER(name) LIKE LOWER('%#{q}%') OR LOWER(description) LIKE LOWER('%#{q}%') 
                                                  OR LOWER(chip_id) LIKE LOWER('%#{q}%') OR LOWER(color) LIKE LOWER('%#{q}%') 
                                                  OR LOWER(primary_breed) LIKE LOWER('%#{q}%') OR LOWER(secondary_breed) LIKE LOWER('%#{q}%')" }}
  scope :search_by_name, lambda { |q| { :conditions => "LOWER(id) LIKE LOWER('%#{q}%') OR LOWER(name) LIKE LOWER('%#{q}%')", :limit => 4 }}                                              
                                                
  private
    def primary_breed_exists
      if self.primary_breed && self.animal_type_id
        if Breed.where(:name => primary_breed).blank?
          errors.add(:primary_breed, "must contain a valid breed from the list")
        end
      end
    end

    def secondary_breed_exists
      if self.is_mix_breed && !self.secondary_breed.blank?
        if Breed.where(:name => secondary_breed).blank?
          errors.add(:secondary_breed, "must contain a valid breed from the list")
        end
      end
    end

    def update_status_change_date
      self.status_change_date = Date.today
    end
    
    def check_status_change
      if self.animal_status_id_changed?
        update_status_change_date
      end
    end
    
end


#  OR
# validates_presence_of :animal_type, :message => 'needs to be selected'
# validates_presence_of :animal_status, :message => 'needs to be selected'

# validates_attachment_presence :photo

# has_attached_file :photo, :styles => { :small => "150x150>" },
#                   :url  => "/assets/products/:id/:style/:basename.:extension",
#                   :path => ":rails_root/public/assets/products/:id/:style/:basename.:extension"



# STATUS = { "available_for_adoption" => "Available for Adoption", 
#            "adopted" => "Adopted", 
#            "foster_care" => "Foster Care",
#            "new_intake" => "New Intake", 
#            "in_transit" => "In Transit",
#            "on_hold_behavioral" => "On Hold - Behavioral",
#            "on_hold_medical" => "On Hold - Medical",
#            "on_hold_stray_intake" => "On Hold - Stray Intake",
#            "deceased" => "Deceased",
#            "euthanized" => "Euthanized" }
