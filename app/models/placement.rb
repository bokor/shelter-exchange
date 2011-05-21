class Placement < ActiveRecord::Base
  default_scope :order => 'created_at DESC'
  
  # Constants
  PLACEMENT_TYPE = %w[adopted foster_care]
  
  # Associations
  belongs_to :shelter, :readonly => true
  belongs_to :animal, :readonly => true
  belongs_to :parent, :readonly => true

  has_many :comments, :as => :commentable, :dependent => :destroy
  
  accepts_nested_attributes_for :comments, :allow_destroy => true, :reject_if => proc { |attributes| attributes['comment'].blank? }

  # Validations
  validates :animal_id, :presence => {:message => 'needs to be selected'}
  validates :placement_type, :presence => {:in => PLACEMENT_TYPE, :message => 'needs to be selected'}
  
  # Scopes
  scope :adopted, includes([:animal, :shelter]).where(:placement_type => :adopted)
  scope :foster_care, includes([:animal, :shelter]).where(:placement_type => :foster_care)
  
end