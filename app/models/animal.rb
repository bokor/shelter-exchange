class Animal < ActiveRecord::Base
  # Concerns
  include Photoable, Statusable, Typeable
  # Animal Namespaced
  include Reportable, Searchable, Mappable, Transferrable, Apiable
  
  default_scope :order => 'animals.updated_at DESC', :limit => 250

  # Callbacks
  #----------------------------------------------------------------------------  
  before_save :change_status_date!
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
  validates :primary_breed, :breed => true
  validates :secondary_breed, :breed => true, :allow_blank => true
  validates :sex, :presence => true
  validates :microchip, :uniqueness => { :allow_blank => true, :scope => :shelter_id, :message => "already exists in your shelter. Please return to the main Animal page and search by this microchip number to locate this record." }  
  validates :special_needs, :presence => { :if => :special_needs? }
  validates :video_url, :video_url_format => true, :allow_blank => true
  validates :date_of_birth, :date_format => true
  validates :arrival_date, :date_format => true
  validates :euthanasia_date, :date_format => true
  
    
  # Scopes 
  #----------------------------------------------------------------------------
  scope :latest, lambda { |status, limit| includes(:shelter).send(status).reorder("status_change_date DESC").limit(limit) }
      
  
  # Scopes - Dashboard - Recent Activity
  #----------------------------------------------------------------------------
  def self.recent_activity(limit=10)
    includes(:animal_type, :animal_status).reorder("animals.updated_at DESC").limit(limit)
  end
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
       
       
  # Private Methods
  #----------------------------------------------------------------------------                                       
  private
  
    def is_kill_shelter?
      @shelter ||= self.shelter.kill_shelter?
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
        
end

