class Animal < ActiveRecord::Base
  default_scope :order => 'animals.status_change_date DESC', :limit => 250
  before_save :check_status_changed?
  after_save :create_status_history!
  
  attr_accessor :status_history_reason
  
  # Pagination - Per Page
  # Rails.env.development? ? PER_PAGE = 4 : PER_PAGE = 25
  PER_PAGE = 25
  
  # Associations
  belongs_to :animal_type, :readonly => true
  belongs_to :animal_status, :readonly => true
  belongs_to :accommodation
  belongs_to :shelter

  has_many :placements, :dependent => :destroy
  has_many :notes, :as => :notable, :dependent => :destroy
  has_many :alerts, :as => :alertable, :dependent => :destroy
  has_many :tasks, :as => :taskable, :dependent => :destroy
  has_many :status_histories, :dependent => :destroy
  has_many :transfers, :dependent => :destroy
  
  has_attached_file :photo, :whiny => false, 
                            :default_url => "/images/default_:style_photo.jpg", 
                            :storage => :s3,
                            :s3_credentials => S3_CREDENTIALS,
                            :path => "/:class/:attachment/:id/:style/:basename.:extension",
                            :styles => { :small => ["250x150>", :jpg],
                                         :medium => ["350x250>", :jpg],
                                         :large => ["500x400>", :jpg], 
                                         :thumb => ["100x75#", :jpg] }
  
  # has_attached_file :photo, :whiny => false, 
  #                           :default_url => "/images/default_:style_photo.jpg", 
  #                           :url => "/system/:class/:attachment/:id/:style/:basename.:extension",
  #                           :path => ":rails_root/public/system/:class/:attachment/:id/:style/:basename.:extension",
  #                           :styles => { :small => ["250x150>", :jpg],
  #                                        :medium => ["350x250>", :jpg],
  #                                        :large => ["500x400>", :jpg], 
  #                                        :thumb => ["100x75#", :jpg] } 

  # Validations
  validates :name, :presence => true
  validates :animal_type_id, :presence => { :message => 'needs to be selected' }
  validates :animal_status_id, :presence => { :message => 'needs to be selected' }
  validates :microchip, :uniqueness => { :allow_blank => true, :scope => :shelter_id, :message => "already exists in your shelter. Please return to the main Animal page and search by this microchip number to locate this record." }
  
  # Custom Validations
  validates :primary_breed, :presence => { :if => :primary_breed_exists? }
  validates :secondary_breed, :presence => { :if => :secondary_breed_exists? }
  validates :status_history_reason, :presence => { :if => :status_history_reason_required? }
  
  # Custom Validations - If Kill Shelter
  validates :arrival_date, :presence => { :message => "must be selected", :if => :is_kill_shelter? }
  validates :hold_time, :presence => { :if => :is_kill_shelter? }
  validates :euthanasia_scheduled, :presence => { :message => "must be selected", :if => :is_kill_shelter? }
  
  # Custom Validations - Photo
  validates_attachment_size :photo, :less_than => 1.megabytes, :message => "needs to be 1 MB or less", :if => Proc.new { |imports| !imports.photo.file? }
  validates_attachment_content_type :photo, :content_type => ["image/jpeg", "image/png", "image/gif"], :message => "needs to be a JPG, PNG, or GIF file"

  
  # Scopes - Searches
  scope :auto_complete, lambda { |q| includes(:animal_type, :animal_status).where("LOWER(name) LIKE LOWER('%#{q}%')") }
  scope :search, lambda { |q| includes(:animal_type, :animal_status).where("LOWER(id) LIKE LOWER('%#{q}%') OR LOWER(name) LIKE LOWER('%#{q}%') OR LOWER(description) LIKE LOWER('%#{q}%')
                                                                            OR LOWER(microchip) LIKE LOWER('%#{q}%') OR LOWER(color) LIKE LOWER('%#{q}%') OR LOWER(weight) LIKE LOWER('%#{q}%')
                                                                            OR LOWER(primary_breed) LIKE LOWER('%#{q}%') OR LOWER(secondary_breed) LIKE LOWER('%#{q}%')") }
  scope :search_by_name, lambda { |q| includes(:animal_type, :animal_status).where("LOWER(id) LIKE LOWER('%#{q}%') OR LOWER(name) LIKE LOWER('%#{q}%')") }                                              
  
  # Scopes - Statuses
  scope :active, where(:animal_status_id => AnimalStatus::ACTIVE)
  scope :non_active, where(:animal_status_id => AnimalStatus::NON_ACTIVE)
  scope :available_for_adoption, where(:animal_status_id => AnimalStatus::AVAILABLE_FOR_ADOPTION)
  scope :adopted, where(:animal_status_id => AnimalStatus::ADOPTED)
  scope :foster_care, where(:animal_status_id => AnimalStatus::FOSTER_CARE)
  scope :reclaimed, where(:animal_status_id => AnimalStatus::RECLAIMED)
  scope :euthanized, where(:animal_status_id => AnimalStatus::EUTHANIZED)
  def self.latest(num)
    unscoped.order("animals.created_at DESC").limit(5)
  end
  
  # Scopes - Maps
  def self.community_animals(shelter_ids, filters={})
    scope = scoped{}
    scope = scope.includes(:animal_type, :animal_status, :shelter)
    scope = scope.where(:shelter_id => shelter_ids)
    scope = scope.where(:euthanasia_scheduled => Date.today..Date.today + 2.weeks) unless filters[:euthanasia_only].blank? or !filters[:euthanasia_only]
    scope = scope.filter_animal_type(filters[:animal_type]) unless filters[:animal_type].blank?
    scope = scope.filter_breed(filters[:breed]) unless filters[:breed].blank?
    scope = scope.filter_sex(filters[:sex]) unless filters[:sex].blank?
    
    scope = scope.filter_animal_status(filters[:animal_status]) unless filters[:animal_status].blank?
    scope = scope.active unless filters[:animal_status].present?
    
    scope
  end

  # def self.map_euthanasia_list(shelter_ids, filters={})
  #   scope = scoped{}
  #   scope = scope.includes(:animal_type, :animal_status)
  #   scope = scope.where(:shelter_id => shelter_ids, :euthanasia_scheduled => Date.today..Date.today + 2.weeks)
  #   scope = scope.filter_animal_type(filters[:animal_type]) unless filters[:animal_type].blank?
  #   scope = scope.filter_breed(filters[:breed]) unless filters[:breed].blank?
  #   scope = scope.filter_sex(filters[:sex]) unless filters[:sex].blank?
  #   scope = scope.filter_animal_status(filters[:animal_status]) unless filters[:animal_status].blank?
  #   scope = scope.active unless filters[:animal_status].present?
  #   
  #   scope
  # end
  
  def self.filter_animal_type(animal_type)
    where(:animal_type_id => animal_type)
  end
  
  def self.filter_breed(breed)
    where("animals.primary_breed = ? OR animals.secondary_breed = ?", breed, breed)
    # where(self.arel_table[:primary_breed].eq(breed).or(self.arel_table[:secondary_breed].eq(breed)))
  end
  
  def self.filter_sex(sex)
    where(:sex => sex.downcase)
  end
  
  def self.filter_animal_status(animal_status)
    where(:animal_status_id => animal_status)
  end

  
  # Scopes - Reporting
  scope :count_by_type, select("count(*) count, animal_types.name").joins(:animal_type).group(:animal_type_id) 
  scope :count_by_status, select("count(*) count, animal_statuses.name").joins(:animal_status).group(:animal_status_id)
  scope :current_month, where(:status_change_date => Date.today.beginning_of_month..Date.today.end_of_month)
  scope :year_to_date, where(:status_change_date => Date.today.beginning_of_year..Date.today.end_of_year) 
  
  def self.totals_by_month(year, date_type, with_type=false)
    start_date = year.blank? ? Date.today.beginning_of_year : Date.parse("#{year}0101").beginning_of_year
    end_date = year.blank? ? Date.today.end_of_year : Date.parse("#{year}0101").end_of_year
    scope = scoped{}
    
    if with_type
      scope = scope.select("animal_types.name as type").joins(:animal_type).group(:animal_type_id)
    else
      scope = scope.select("'Total' as type")
    end
    
    start_date.month.upto(end_date.month) do |month|
      scope = scope.select("COUNT(CASE WHEN animals.#{date_type.to_s} BETWEEN '#{start_date.beginning_of_month}' AND '#{start_date.end_of_month}' THEN 1 END) AS #{Date::MONTHNAMES[month].downcase}")
      start_date = start_date.next_month
    end

    scope
  end
                                                 
  private

    def primary_breed_exists?
      if self.primary_breed.blank?
        true
      else
        unless self.animal_type_id == 7  # Bypass Type = Other
          if Breed.valid_for_animal(self.primary_breed, self.animal_type_id).blank?
            errors.add(:primary_breed, "must contain a valid breed from the list")
          end
        end
      end
    end

    def secondary_breed_exists?
      unless self.animal_type_id == 7 # Bypass Type = Other
        if self.is_mix_breed and self.secondary_breed.present?
          if Breed.valid_for_animal(self.secondary_breed, self.animal_type_id).blank?
            errors.add(:secondary_breed, "must contain a valid breed from the list")
          end
        end
      end
    end
    
    def is_kill_shelter?
      @shelter ||= Shelter.find_by_id(self.shelter_id).is_kill_shelter
    end
        
    def status_history_reason_required?
      self.animal_status_id.present? and (self.new_record? or self.animal_status_id_changed?)
    end
    
    def check_status_changed?
      if self.new_record? or self.animal_status_id_changed?
        self.status_change_date = Date.today
      end
    end
    
    def create_status_history!
      if self.new_record? or self.animal_status_id_changed?
        status_history = StatusHistory.new(:shelter_id => self.shelter_id, :animal_id => self.id, :animal_status_id => self.animal_status_id, :reason => @status_history_reason)
        status_history.save
      end
    end

end


# Virtual Attributes
# def status_history_reason
#   @status_history_reason ||= ""
# end
# 
# def status_history_reason=(value)
#   @status_history_reason = value
# end

# def dob_month
#   @dob_month ||= ""
# end
# 
# def dob_month=(value)
#   @dob_month = value
# end
# 
# def dob_day
#   @dob_day ||= ""
# end
# 
# def dob_day=(value)
#   @dob_day = value
# end
# 
# def dob_year
#   @dob_year ||= ""
# end
# 
# def dob_year=(value)
#   @dob_year = value
# end