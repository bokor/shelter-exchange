class Alert < ActiveRecord::Base
  default_scope :order => 'alerts.created_at DESC'

  # Constants
  #----------------------------------------------------------------------------
  SEVERITIES = %w[high medium low].freeze

  # Associations
  #----------------------------------------------------------------------------
  belongs_to :shelter, :readonly => true
  belongs_to :alertable, :polymorphic => true

  # Validations
  #----------------------------------------------------------------------------
  validates :title, :presence => true
  validates :severity, :presence => { :message => 'needs to be selected' }

  # Scopes
  #----------------------------------------------------------------------------
  scope :active, where(:stopped => false)
  scope :stopped, where(:stopped => true)
  scope :with_alertable, includes(:alertable)
  scope :for_shelter, where(:alertable_type => nil)
  scope :for_animals, with_alertable.where(:alertable_type => Animal)


  # Class Methods
  #----------------------------------------------------------------------------
  def self.recent_activity(limit=10)
    with_alertable.reorder("alerts.updated_at DESC").limit(limit)
  end

  # Instance Methods
  #----------------------------------------------------------------------------
  def stopped?
    self.stopped
  end

  def active?
    !self.stopped
  end

  def alertable?
    !!self.alertable
  end
end
