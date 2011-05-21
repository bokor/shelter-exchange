class Animal < ActiveRecord::Base
  default_scope :order => 'animals.status_change_date DESC', :limit => 250
  
  after_validation :photo_reverted?
  before_save :check_status_changed?
  after_save :create_status_history!
  
  attr_accessor :status_history_reason, 
                :dob_month, :dob_day, :dob_year,
                :arrival_date_month, :arrival_date_day, :arrival_date_year,
                :euthanasia_scheduled_month, :euthanasia_scheduled_day, :euthanasia_scheduled_year
  
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
  before_post_process :photo_valid?                                       

  # Validations
  validates :name, :presence => true
  validates :animal_type_id, :presence => { :message => 'needs to be selected' }
  validate :primary_breed_valid?
  validate :secondary_breed_valid? 
  validates :animal_status_id, :presence => { :message => 'needs to be selected' }
  validate :status_history_reason_required?
  validates :sex, :presence => true
  validate :date_of_birth_valid?
  validates :microchip, :uniqueness => { :allow_blank => true, :scope => :shelter_id, :message => "already exists in your shelter. Please return to the main Animal page and search by this microchip number to locate this record." }
  validate :arrival_date_valid?
  validates :hold_time, :presence => { :if => :is_kill_shelter? }
  validate :euthanasia_scheduled_valid?
  
  # Custom Validations - Photo
  validates_attachment_size :photo, :less_than => IMAGE_SIZE, :message => "needs to be 4 MB or less" #, :if => Proc.new { |imports| !imports.photo.file? }
  validates_attachment_content_type :photo, :content_type => IMAGE_TYPES, :message => "needs to be a JPG, PNG, or GIF file"

  
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
  
  # Finalized Transfer Request
  def complete_transfer_request!(current_shelter, requestor_shelter)
    self.animal_status_id = AnimalStatus::NEW_INTAKE
    self.status_history_reason = "Transferred from #{current_shelter.name}"
    self.shelter_id = requestor_shelter.id
    self.arrival_date = nil
    self.hold_time = nil
    self.euthanasia_scheduled = nil
    self.accommodation_id = nil
    if self.save(:validate => false)
      create_status_history!(true)
      self.tasks.delete_all
      self.alerts.delete_all
    end
    # self.photo.reprocess!
  end

                                                 
  private
  
    def is_kill_shelter?
      @shelter ||= Shelter.find_by_id(self.shelter_id).is_kill_shelter
    end

    def primary_breed_valid?
      unless self.animal_type_id.blank?
        if self.primary_breed.blank?
          errors.add_on_blank(:primary_breed)
        else
          unless self.animal_type_id == 7  # Bypass Type = Other
            if Breed.valid_for_animal(self.primary_breed, self.animal_type_id).blank?
              errors.add(:primary_breed, "must contain a valid breed from the list")
            end
          end
        end
      end
    end

    def secondary_breed_valid?
      unless self.animal_type_id == 7 # Bypass Type = Other
        if self.is_mix_breed and self.secondary_breed.present?
          if Breed.valid_for_animal(self.secondary_breed, self.animal_type_id).blank?
            errors.add(:secondary_breed, "must contain a valid breed from the list")
          end
        end
      end
    end
    
    def date_of_birth_valid?
      unless self.dob_year.blank? and self.dob_month.blank? and self.dob_day.blank?
        begin
          self.date_of_birth = Date.civil(self.dob_year.to_i, self.dob_month.to_i, self.dob_day.to_i)
        rescue ArgumentError
           errors.add(:date_of_birth, "is an invalid date format")
        end
      end
    end
    
    def arrival_date_valid?
      if is_kill_shelter?
        unless self.arrival_date_year.blank? and self.arrival_date_month.blank? and self.arrival_date_day.blank?
          begin
            self.arrival_date = Date.civil(self.arrival_date_year.to_i, self.arrival_date_month.to_i, self.arrival_date_day.to_i)
          rescue ArgumentError
            errors.add(:arrival_date, "is an invalid date format")
          end
        else
          errors.add_on_blank(:arrival_date)
        end
      end 
    end
    
    def euthanasia_scheduled_valid?
      if is_kill_shelter?
        unless self.euthanasia_scheduled_year.blank? and self.euthanasia_scheduled_month.blank? and self.euthanasia_scheduled_day.blank?
          begin
            self.euthanasia_scheduled = Date.civil(self.euthanasia_scheduled_year.to_i, self.euthanasia_scheduled_month.to_i, self.euthanasia_scheduled_day.to_i)
          rescue ArgumentError
            errors.add(:euthanasia_scheduled, "is an invalid date format")
          end
        else
          errors.add_on_blank(:euthanasia_scheduled)
        end
      end
    end
        
    def check_status_changed?
      if self.new_record? or self.animal_status_id_changed?
        self.status_change_date = Date.today
      end
    end
    
    def status_history_reason_required?
      self.animal_status_id.present? and (self.new_record? or self.animal_status_id_changed?)
    end
    
    def create_status_history!(force = false)
      if self.new_record? or self.animal_status_id_changed? or force
        status_history = StatusHistory.new(:shelter_id => self.shelter_id, :animal_id => self.id, :animal_status_id => self.animal_status_id, :reason => @status_history_reason)
        status_history.save
      end
    end

    
    def photo_valid?
      photo? and photo_file_size < IMAGE_SIZE
    end
    
    def photo?
      IMAGE_TYPES.include?(photo_content_type)
    end
    
    def photo_reverted?
      unless self.errors[:photo_file_size].blank? or self.errors[:photo_content_type].blank?
        self.photo.instance_write(:file_name, self.photo_file_name_was) 
        self.photo.instance_write(:file_size, self.photo_file_size_was) 
        self.photo.instance_write(:content_type, self.photo_content_type_was)
      end
    end

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
