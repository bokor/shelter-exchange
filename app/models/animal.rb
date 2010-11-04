class Animal < ActiveRecord::Base
  
  # Hash (Key/Value Pairs)
  SEX = [ "Male", "Female" ]
  # Will_Paginate
  PER_PAGE = 5
  
  # Associations
  belongs_to :animal_type, :readonly => true
  belongs_to :animal_status, :readonly => true
  belongs_to :shelter
  
  has_many :breeds, :readonly => true
  has_many :notes, :as => :subject, :dependent => :destroy, :order => "created_at DESC"
  has_many :alerts, :as => :subject, :dependent => :destroy, :order => "created_at DESC"
  has_many :tasks, :as => :subject, :dependent => :destroy, :order => "created_at DESC"
  
  has_attached_file :photo, :default_url => "/images/default_:style_photo.jpg", 
                            :styles => { :small => ["250x150>", :jpg],
                                         :medium => ["350x250>", :jpg],
                                         :large => ["500x400>", :jpg], 
                                         :thumb => ["100x75#", :jpg] } 
  # has_attached_file :photo, :styles => { :small => "150x150>" },
  #                   :url  => "/assets/products/:id/:style/:basename.:extension",
  #                   :path => ":rails_root/public/assets/products/:id/:style/:basename.:extension"

  

  # Validations
  validates_presence_of :name
  validates_presence_of :animal_type_id, :message => 'needs to be selected'
  validates_presence_of :animal_status_id, :message => 'needs to be selected'
  #  OR
  # validates_presence_of :animal_type, :message => 'needs to be selected'
  # validates_presence_of :animal_status, :message => 'needs to be selected'
  
  # validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 1.megabytes, :message => 'needs to be 1 MB or smaller'
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif'], :message => 'needs to be a JPG, PNG, or GIF file'


  validate :primary_breed, :presence => true, :if => :primary_breed_exists
  validate :secondary_breed, :presence => true, :if => :secondary_breed_exists

  # Callbacks

  # Scopes
  # scope :live_search, lambda { |q| { 
  #   :conditions => ["LOWER(name) LIKE LOWER('%?%')", q.to_s] 
  # }}

  private
    def primary_breed_exists
      if self.primary_breed && self.animal_type_id
        if Breed.find_by_name(primary_breed).blank?
          errors.add(:primary_breed, "must contain a valid breed from the list")
        end
      end
    end

    def secondary_breed_exists
      if self.is_mix_breed && !self.secondary_breed.blank?
        if Breed.find_by_name(secondary_breed).blank?
          errors.add(:secondary_breed, "must contain a valid breed from the list")
        end
      end
    end
    
end
