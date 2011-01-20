class Animal < ActiveRecord::Base
  default_scope :order => 'created_at DESC'
  before_create :update_status_change_date
  before_save :check_status_change
  
  # Development
  PER_PAGE = 4
  # Production
  #PER_PAGE = 25
  SEX = [ "Male", "Female" ]
  
  # Associations
  belongs_to :animal_type, :readonly => true
  belongs_to :animal_status, :readonly => true
  belongs_to :accommodation
  belongs_to :shelter
  
  has_many :placements, :dependent => :destroy
  has_many :notes, :as => :notable, :dependent => :destroy
  has_many :alerts, :as => :alertable, :dependent => :destroy
  has_many :tasks, :as => :taskable, :dependent => :destroy
  
  has_attached_file :photo, :whiny => false, :default_url => "/images/default_:style_photo.jpg", 
                            :styles => { :small => ["250x150>", :jpg],
                                         :medium => ["350x250>", :jpg],
                                         :large => ["500x400>", :jpg], 
                                         :thumb => ["100x75#", :jpg] } 

  # Validations
  validates_presence_of :name
  validates_presence_of :animal_type_id, :message => 'needs to be selected'
  validates_presence_of :animal_status_id, :message => 'needs to be selected'
  
  # Custom Validations
  validate :primary_breed, :presence => true, :if => :primary_breed_exists
  validate :secondary_breed, :presence => true, :if => :secondary_breed_exists
  validate :arrival_date, :presence => true, :if => :arrival_date_required
  validate :euthanasia_scheduled, :presence => true, :if => :euthanasia_scheduled_required
  validate :hold_time, :presence => true, :if => :hold_time_required
  
  validates_attachment_size :photo, :less_than => 1.megabytes, :message => 'needs to be 1 MB or smaller'
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif'], :message => 'needs to be a JPG, PNG, or GIF file'


  
  
  # Scopes
  scope :auto_complete, lambda { |q| where("name LIKE LOWER('%#{q}%')") }
  scope :live_search, lambda { |q| where("id LIKE LOWER('%#{q}%') OR name LIKE LOWER('%#{q}%') OR description LIKE LOWER('%#{q}%') 
                                          OR chip_id LIKE LOWER('%#{q}%') OR color LIKE LOWER('%#{q}%') 
                                          OR age LIKE LOWER('%#{q}%') OR weight LIKE LOWER('%#{q}%') 
                                          OR primary_breed LIKE LOWER('%#{q}%') OR secondary_breed LIKE LOWER('%#{q}%')") }
  scope :search_by_name, lambda { |q| where("id LIKE LOWER('%#{q}%') OR name LIKE LOWER('%#{q}%')").limit(4) }                                              
     

  
                                                 
  private

    def primary_breed_exists
      if self.primary_breed && self.animal_type_id
        if Breed.valid_for_animal(primary_breed, animal_type_id).blank?
          errors.add(:primary_breed, "must contain a valid breed from the list")
        end
      end
    end

    def secondary_breed_exists
      if self.is_mix_breed && !self.secondary_breed.blank?
        if Breed.valid_for_animal(secondary_breed, animal_type_id).blank?
          errors.add(:secondary_breed, "must contain a valid breed from the list")
        end
      end
    end
    
    # def euthanasia_field_required(field)
    #   if @is_kill_shelter && field.blank?
    #     errors.add(field, "must be entered")
    #   end
    # end
    
    def is_kill_shelter?
      Shelter.find_by_id(self.shelter_id).is_kill_shelter
    end
    
    def arrival_date_required
      if is_kill_shelter? && self.arrival_date.blank?
        errors.add(:arrival_date, "must be selected")
      end
    end

    def euthanasia_scheduled_required
      if is_kill_shelter? && self.euthanasia_scheduled.blank?
        errors.add(:euthanasia_scheduled, "must be selected")
      end
    end
        
    def hold_time_required
      if is_kill_shelter? && self.hold_time.blank?
        errors.add(:hold_time, "must be entered")
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


# has_many :parents, :through => :placements
# has_many :breeds, :readonly => true


# def clear_photo
#   self.photo.queued_for_write.clear if !photo.dirty?
#   # self.photo = nil
# end

# def delete_photo=(value)
#   @delete_photo = !value.to_i.zero?
# end
# 
# def delete_photo
#   !!@delete_photo
# end
# alias_method :delete_photo?, :delete_photo

# def test_save
#   if @delete_avatar == 1.to_s 
#     self.avatar = nil 
#     self.avatar.queued_for_write.clear
#   end
# end


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
