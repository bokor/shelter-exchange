class Placement < ActiveRecord::Base
  default_scope :order => 'placements.created_at DESC'

  # Constants
  #----------------------------------------------------------------------------
  STATUS = %w[adopted foster_care].freeze

  # Associations
  #----------------------------------------------------------------------------
  belongs_to :shelter, :readonly => true
  belongs_to :animal, :readonly => true
  belongs_to :parent, :readonly => true

  has_many :comments, :as => :commentable, :dependent => :destroy

  # Nested Attributes
  #----------------------------------------------------------------------------
  accepts_nested_attributes_for :comments, :allow_destroy => true, :reject_if => proc { |attributes| attributes['comment'].blank? }

  # Validations
  #----------------------------------------------------------------------------
  validates :animal_id, :presence => {:message => 'needs to be selected'}
  validates :status, :presence => {:in => STATUS, :message => 'needs to be selected'}

  # Scopes
  #----------------------------------------------------------------------------
  scope :adopted, includes(:shelter, :animal => [:photos, :animal_type]).where(:status => "adopted")
  scope :foster_care, includes(:shelter, :animal => [:photos, :animal_type]).where(:status => "foster_care")
end

