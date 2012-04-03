class Shelter < ActiveRecord::Base
  # Concerns
  include Logoable, Geocodeable
  # Shelter Namespaced
  include Cleanable, Searchable, Tokenable
  
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
  validates :website, :facebook, :allow_blank => true, :url_format => true
  validates :twitter, :twitter_format => true, :allow_blank => true        

  
  # Scopes
  #----------------------------------------------------------------------------
  scope :auto_complete, lambda { |q|  where("name LIKE ?", "%#{q}%") }
  scope :kill_shelters, where(:is_kill_shelter => true).order(:name) 
  scope :no_kill_shelters, where(:is_kill_shelter => false).order(:name) 
  scope :latest, lambda {|limit| order("created_at desc").limit(limit) }
  scope :active, where(:status => "active")
  scope :inactive, where("status != 'active'")
  scope :suspended, where(:status => "suspended")
  scope :cancelled, where(:status => "cancelled")
  
    
  # Instance Methods
  #----------------------------------------------------------------------------
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
  
end
      