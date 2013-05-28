class Note < ActiveRecord::Base
  default_scope :order => 'notes.created_at DESC'

  # Constants
  #----------------------------------------------------------------------------
  DEFAULT_CATEGORY = "general"
  CATEGORIES = %w[general medical behavioral intake].freeze

  # Associations
  #----------------------------------------------------------------------------
  belongs_to :shelter, :readonly => true
  belongs_to :notable, :polymorphic => true

  has_many :documents, :as => :attachable, :dependent => :destroy

  # Validations
  #----------------------------------------------------------------------------
  validates :title, :presence => true
  validates :category, :inclusion => { :in => CATEGORIES, :message => "needs to be selected" }

  # Scopes
  #----------------------------------------------------------------------------
  scope :without_hidden, where(:hidden => false)

  # Instance Methods
  #----------------------------------------------------------------------------
  def notable?
    !!self.notable
  end
end
