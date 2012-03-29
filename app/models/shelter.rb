class Shelter < ActiveRecord::Base
  include Logoable, Geocodeable, Phoneable
  

  # Callbacks
  #----------------------------------------------------------------------------
  before_save :clear_status_reason
  
  # Constants
  #----------------------------------------------------------------------------
  STATUSES = ["active", "suspended", "cancelled"].freeze
  
  # Assocations
  #----------------------------------------------------------------------------
  belongs_to :account
  has_many :users, :through => :account

  has_many :locations, :dependent => :destroy
  has_many :accommodations, :dependent => :destroy
  has_many :placements, :dependent => :destroy
  has_many :animals, :dependent => :destroy
  has_many :notes, :dependent => :destroy
  has_many :tasks, :dependent => :destroy
  has_many :alerts, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :items, :dependent => :destroy
  has_many :capacities, :dependent => :destroy
  has_many :status_histories, :dependent => :destroy
  has_many :transfers, :dependent => :destroy
  has_many :integrations, :dependent => :destroy

  # Nested Attributes
  #----------------------------------------------------------------------------  
  accepts_nested_attributes_for :items, :allow_destroy => true
   
  # Validations
  #----------------------------------------------------------------------------
  validates :name, :presence => true
  validates :phone, :presence => true, :phone_format => true
  validates :email, :presence => true, :uniqueness => true, :allow_blank => true, :email_format => true
  validates :time_zone, :inclusion => { :in => ActiveSupport::TimeZone.us_zones.map { |z| z.name }, :message => "is not a valid US Time Zone" }
  validates :access_token, :uniqueness => true, :on => :generate_access_token!    
  validates :website, :facebook, :allow_blank => true, :url_format => true
  validates :twitter, :twitter_format => true, :allow_blank => true        

  
  # Scopes
  #----------------------------------------------------------------------------
  scope :auto_complete, lambda { |q|  where("name LIKE ?", "%#{q}%") }
  scope :by_access_token, lambda { |access_token| where(:access_token => access_token) }
  scope :kill_shelters, where(:is_kill_shelter => true).order(:name) 
  scope :no_kill_shelters, where(:is_kill_shelter => false).order(:name) 
  scope :latest, lambda {|limit| order("created_at desc").limit(limit) }
  scope :active, where(:status => "active")
  scope :inactive, where("status != 'active'")
  scope :suspended, where(:status => "suspended")
  scope :cancelled, where(:status => "cancelled")
  
  def self.live_search (q, shelter)
    scope = self.scoped
    scope = scope.where(shelter)
    scope = scope.where("name LIKE ? OR city LIKE ? OR zip_code LIKE ? OR 
                         facebook LIKE ? OR twitter LIKE ? or email LIKE ?", 
                         "%#{q}%", "%#{q}%", "%#{q}%", "%#{q}%", "%#{q}%", "%#{q}%") unless q.blank?
    scope
  end

    
  # Instance Methods
  #----------------------------------------------------------------------------
  def generate_access_token!
    # self.access_token = ActiveSupport::SecureRandom.base64(10)
    self.access_token = ActiveSupport::SecureRandom.hex(15)
    save!
  end
  
  def kill_shelter?
    self.is_kill_shelter
  end
  
  def no_kill_shelter?
    !self.is_kill_shelter
  end
  
  def active?
    self.status == "active"
  end
  
  def inactive?
    self.suspended? || self.cancelled?
  end
  
  def suspended?
    self.status == "suspended"
  end
  
  def cancelled?
    self.status == "cancelled"
  end
  
  private
    
    def clear_status_reason
      self.status_reason = "" if self.status_changed? && self.active?
    end
  
end
      