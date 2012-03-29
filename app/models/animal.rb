class Animal < ActiveRecord::Base
  include Photoable
  
  default_scope :order => 'animals.updated_at DESC', :limit => 250

  # Callbacks
  #----------------------------------------------------------------------------  
  before_save :change_status_date!, :clean_fields
  after_save :create_status_history!

  # Getters/Setters
  #----------------------------------------------------------------------------  
  attr_accessor :status_history_reason, 
                :date_of_birth_month, :date_of_birth_day, :date_of_birth_year,
                :arrival_date_month, :arrival_date_day, :arrival_date_year,
                :euthanasia_date_month, :euthanasia_date_day, :euthanasia_date_year
  
  # Constants
  #----------------------------------------------------------------------------
  PER_PAGE = 25
  PER_PAGE_API = 25

  
  # Associations
  #----------------------------------------------------------------------------
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
  

  # Validations
  #----------------------------------------------------------------------------
  validates :name, :presence => true
  validates :animal_type_id, :presence => { :message => 'needs to be selected' }
  validates :animal_status_id, :presence => { :message => 'needs to be selected' }
  validates :sex, :presence => true
  validates :microchip, :uniqueness => { :allow_blank => true, :scope => :shelter_id, :message => "already exists in your shelter. Please return to the main Animal page and search by this microchip number to locate this record." }  
  validates :special_needs, :presence => { :if => :special_needs? }
  validates :video_url, :video_url_format => true, :allow_blank => true
  validates :date_of_birth, :date_format => true
  validates :arrival_date, :date_format => true
  validates :euthanasia_date, :date_format => true
  
  validate :primary_breed_valid?
  validate :secondary_breed_valid? 

    
    
  # Scopes - Statuses
  #----------------------------------------------------------------------------
  scope :active, where(:animal_status_id => AnimalStatus::ACTIVE)
  scope :non_active, where(:animal_status_id => AnimalStatus::NON_ACTIVE)
  scope :available_for_adoption, where(:animal_status_id => AnimalStatus::STATUSES[:available_for_adoption])
  scope :adopted, where(:animal_status_id => AnimalStatus::STATUSES[:adopted])
  scope :foster_care, where(:animal_status_id => AnimalStatus::STATUSES[:foster_care])
  scope :reclaimed, where(:animal_status_id => AnimalStatus::STATUSES[:reclaimed])
  scope :euthanized, where(:animal_status_id => AnimalStatus::STATUSES[:euthanized])
  scope :transferred, where(:animal_status_id => AnimalStatus::STATUSES[:transferred])
  scope :latest, lambda { |status, limit| includes(:shelter).send(status).reorder("status_change_date DESC").limit(limit) }
  #----------------------------------------------------------------------------

  
  
  # Scopes - Search
  #----------------------------------------------------------------------------
  scope :auto_complete, lambda { |q| includes(:animal_type, :animal_status).where("name LIKE ?", "%#{q}%") }
  scope :search, lambda { |q| includes(:animal_type, :animal_status).where("id LIKE ? OR name LIKE ? OR description LIKE ? OR microchip LIKE ? OR
                                                                            color LIKE ? OR weight LIKE ? OR primary_breed LIKE ? OR secondary_breed LIKE ?",
                                                                            "%#{q}%", "%#{q}%", "%#{q}%", "%#{q}%", "%#{q}%", "%#{q}%", "%#{q}%", "%#{q}%") }
  scope :search_by_name, lambda { |q| includes(:animal_type, :animal_status).where("id LIKE ? OR name LIKE ?", "%#{q}%", "%#{q}%") }                                              
  
  def self.filter_by_type_status(type, status)
    scope = scoped{}
    scope = scope.includes(:animal_type, :animal_status)
    scope = scope.where(:animal_type_id => type) unless type.blank?
    unless status.blank?
      scope = (status == "active" or status == "non_active") ? scope.send(status) : scope.where(:animal_status_id => status) 
    end
    
    scope
  end
  #----------------------------------------------------------------------------  
    
  
  # Scopes - Dashboard - Recent Activity
  #----------------------------------------------------------------------------
  def self.recent_activity(shelter_id, limit=10)
    includes(:animal_type, :animal_status).where(:shelter_id => shelter_id).reorder("animals.updated_at DESC").limit(limit)
  end
  #----------------------------------------------------------------------------  
  
  
  
  # Scopes - Maps and Filters
  #----------------------------------------------------------------------------
  def self.community_animals(shelter_ids, filters={})
    scope = self.scoped
    scope = scope.includes(:animal_type, :animal_status, :shelter)
    scope = scope.where(:shelter_id => shelter_ids)
    scope = scope.filter_euthanasia_only unless filters[:euthanasia_only].blank? or !filters[:euthanasia_only]
    scope = scope.filter_special_needs_only unless filters[:special_needs_only].blank? or !filters[:special_needs_only]
    scope = scope.filter_animal_type(filters[:animal_type]) unless filters[:animal_type].blank?
    scope = scope.filter_breed(filters[:breed]) unless filters[:breed].blank?
    scope = scope.filter_sex(filters[:sex]) unless filters[:sex].blank?
    
    scope = scope.filter_animal_status(filters[:animal_status]) unless filters[:animal_status].blank?
    scope = scope.active unless filters[:animal_status].present?
    
    scope.reorder("ISNULL(animals.euthanasia_date), animals.euthanasia_date ASC") #.limit(nil)
  end
  
  def self.filter_euthanasia_only
    joins(:shelter).where("shelters.is_kill_shelter = ?", true).where("animals.euthanasia_date < ?", Date.today + 2.weeks)
  end
  
  def self.filter_special_needs_only
    where("animals.has_special_needs = ?", true)
  end
    
  def self.filter_animal_type(animal_type)
    where(:animal_type_id => animal_type)
  end
  
  def self.filter_breed(breed)
    where("animals.primary_breed = ? OR animals.secondary_breed = ?", breed, breed)
  end
  
  def self.filter_sex(sex)
    where(:sex => sex.downcase)
  end
  
  def self.filter_animal_status(animal_status)
    where(:animal_status_id => animal_status)
  end
  #----------------------------------------------------------------------------  
  
  
  # Scopes - Reports
  #----------------------------------------------------------------------------  
  scope :count_by_type, select("count(*) count, animal_types.name").joins(:animal_type).group(:animal_type_id) 
  scope :count_by_status, select("count(*) count, animal_statuses.name").joins(:animal_status).group(:animal_status_id)
  scope :current_month, where(:status_change_date => Date.today.beginning_of_month..Date.today.end_of_month)
  scope :year_to_date, where(:status_change_date => Date.today.beginning_of_year..Date.today.end_of_year) 
  
  def self.type_by_month_year(month, year, shelter_id=nil, state=nil)
    start_date = (month.blank? or year.blank?) ? Date.today : Date.civil(year.to_i, month.to_i, 01)
    range = start_date.beginning_of_month..start_date.end_of_month    
    status_histories = StatusHistory.where(:shelter_id => shelter_id || {}).by_month(range)
    
    scope = scoped{}
    scope = scope.select("count(*) count, animal_types.name")
    scope = scope.joins(:status_histories, :animal_type)
    unless state.blank?
      scope = scope.joins(:shelter) 
      scope = scope.where(:shelters => { :state => state })
    end
    scope = scope.where(:status_histories => {:id => status_histories})
    scope = scope.where(:animal_status_id => AnimalStatus::ACTIVE)
    scope = scope.group(:animal_type_id).limit(nil)
    scope
  end
  
  def self.intake_totals_by_month(year, with_type=false)
    start_date = year.blank? ? Date.today.beginning_of_year : Date.parse("#{year}0101").beginning_of_year
    end_date = year.blank? ? Date.today.end_of_year : Date.parse("#{year}0101").end_of_year
    scope = scoped{}
    
    if with_type
      scope = scope.select("animal_types.name as type").joins(:animal_type).group(:animal_type_id)
    else
      scope = scope.select("'Total' as type")
    end
    
    start_date.month.upto(end_date.month) do |month|
      scope = scope.select("COUNT(CASE WHEN animals.created_at BETWEEN '#{start_date.beginning_of_month}' AND '#{start_date.end_of_month}' THEN 1 END) AS #{Date::MONTHNAMES[month].downcase}")
      start_date = start_date.next_month
    end
    scope = scope.reorder(nil).limit(nil)
    scope
  end
  #----------------------------------------------------------------------------  
  
  
  # Scopes - API
  #----------------------------------------------------------------------------
  def self.api_lookup(types, statuses, current_shelter)
    scope = self.scoped
    scope = scope.includes(:animal_type, :animal_status)
    scope = scope.where(:shelter_id => current_shelter)
    scope = (statuses.blank? ? scope.available_for_adoption : scope.where(:animal_status_id => statuses))
    scope = scope.where(:animal_type_id => types) unless types.blank?
    scope.reorder("ISNULL(animals.euthanasia_date), animals.euthanasia_date ASC").limit(nil)
  end
  #----------------------------------------------------------------------------  
  
  
  # Finalize Transfer Request
  #----------------------------------------------------------------------------
  def complete_transfer_request!(current_shelter, requestor_shelter)
    self.animal_status_id = AnimalStatus::STATUSES[:new_intake]
    self.status_history_reason = "Transferred from #{current_shelter.name}"
    self.status_change_date = Date.today
    self.shelter_id = requestor_shelter.id
    self.arrival_date = Date.today
    self.hold_time = nil
    self.euthanasia_date = nil
    self.accommodation_id = nil
    self.touch(:updated_at)
    self.save(:validate => false)
    self.notes.update_all({:shelter_id => requestor_shelter.id})
    # Delete all Records not needed
    self.status_histories.where(:shelter_id => current_shelter.id).delete_all
    self.tasks.delete_all
    self.alerts.delete_all
  end
  #----------------------------------------------------------------------------  
  
  
  # CSV Exports
  #----------------------------------------------------------------------------

  #----------------------------------------------------------------------------
  
  
  
  # Instance Methods
  #----------------------------------------------------------------------------
  def full_breed
    if mix_breed?
      self.secondary_breed.blank? ? self.primary_breed + " Mix" : self.primary_breed + " & " + self.secondary_breed + " Mix"
    else
      self.primary_breed
    end
  end
  
  def special_needs?
    self.has_special_needs
  end
  
  def mix_breed?
    self.is_mix_breed
  end
  
  def sterilized?
    self.is_sterilized
  end

  def available_for_adoption?
    self.animal_status_id == AnimalStatus::STATUSES[:available_for_adoption]
  end
  
  def adopted?
    self.animal_status_id == AnimalStatus::STATUSES[:adopted]
  end
  
  def reclaimed?
    self.animal_status_id == AnimalStatus::STATUSES[:reclaimed]
  end
  
  def foster_care?
    self.animal_status_id == AnimalStatus::STATUSES[:foster_care]
  end
  
  def deceased?
    self.animal_status_id == AnimalStatus::STATUSES[:deceased]
  end
  
  def euthanized?
    self.animal_status_id == AnimalStatus::STATUSES[:euthanized]
  end
  
  def transferred?
    self.animal_status_id == AnimalStatus::STATUSES[:transferred]
  end

  def dog?
    self.animal_type_id == AnimalType::TYPES[:dog]
  end
  
  def cat?
    self.animal_type_id == AnimalType::TYPES[:cat]
  end
  
  def horse?
    self.animal_type_id == AnimalType::TYPES[:horse]
  end
  
  def rabbit?
    self.animal_type_id == AnimalType::TYPES[:rabbit]
  end
  
  def bird?
    self.animal_type_id == AnimalType::TYPES[:rabbit]
  end
  
  def bird?
    self.animal_type_id == AnimalType::TYPES[:bird]
  end
  
  def reptile?
    self.animal_type_id == AnimalType::TYPES[:reptile]
  end
  
  def other?
    self.animal_type_id == AnimalType::TYPES[:other]
  end
   
  # define_method(:available_for_adoption?) { self.animal_status_id == AnimalStatus::STATUSES[:available_for_adoption] }
  #----------------------------------------------------------------------------  
       
       
       
       
  # Private Methods
  #----------------------------------------------------------------------------
                                            
  private
  
    def is_kill_shelter?
      @shelter ||= self.shelter.kill_shelter?
    end

    def primary_breed_valid?
      unless self.animal_type_id.blank?
        if self.primary_breed.blank?
          errors.add_on_blank(:primary_breed)
        else
          unless self.other?  # Bypass Type = Other
            if Breed.valid_for_animal(self.primary_breed, self.animal_type_id).blank?
              errors.add(:primary_breed, "must contain a valid breed from the list")
            end
          end
        end
      end
    end

    def secondary_breed_valid?
      unless self.other? # Bypass Type = Other
        if self.is_mix_breed and self.secondary_breed.present?
          if Breed.valid_for_animal(self.secondary_breed, self.animal_type_id).blank?
            errors.add(:secondary_breed, "must contain a valid breed from the list")
          end
        end
      end
    end
            
    def change_status_date!
      if self.new_record? or self.animal_status_id_changed?
        self.status_change_date = Date.today
      end
    end
    
    def status_history_reason_required?
      self.animal_status_id.present? and (self.new_record? or self.animal_status_id_changed?)
    end
    
    def create_status_history!
      StatusHistory.create_with(self.shelter_id, self.id, self.animal_status_id, @status_history_reason) if self.new_record? or self.animal_status_id_changed? or self.shelter_id_changed?
    end
        
    def clean_fields
      clean_description
      clean_secondary_breed
      clean_special_needs
    end
    
    def clean_description
      # Remove Microsoft Extra Smart Formatting
      unless self.description.blank?
        self.description.strip!
        self.description.gsub!(/[\u201C\u201D\u201E\u201F\u2033\u2036]/, '"') 
        self.description.gsub!(/[\u2018\u2019\u201A\u201B\u2032\u2035\uFFFD]/, "'") 
        self.description.gsub!(/[\u2013\u2014]/, "-") 
        self.description.gsub!(/\u02C6/, '^')
        self.description.gsub!(/\u2039/, '<')
        self.description.gsub!(/\u203A/, '>')
        self.description.gsub!(/\u2013/, '-')
        self.description.gsub!(/\u2014/, '--')
        self.description.gsub!(/\u2026/, '...')
        self.description.gsub!(/\u00A9/, '&copy;')
        self.description.gsub!(/\u00AE/, '&reg;')
        self.description.gsub!(/\u2122/, '&trade;')
        self.description.gsub!(/\u00BC/, '&frac14;')
        self.description.gsub!(/\u00BD/, '&frac12;')
        self.description.gsub!(/\u00BE/, '&frac34;')
        self.description.gsub!(/[\u02DC\u00A0]/, " ")
      end
    end
    
    def clean_secondary_breed
      self.secondary_breed = nil unless self.mix_breed?
    end
    
    def clean_special_needs
      self.special_needs = nil unless self.special_needs?
    end

end


# where(self.arel_table[:primary_breed].eq(breed).or(self.arel_table[:secondary_breed].eq(breed)))

