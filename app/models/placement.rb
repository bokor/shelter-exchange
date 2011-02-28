class Placement < ActiveRecord::Base
  default_scope :order => 'created_at DESC'
  
  PLACEMENT_TYPE = %w[adopted foster_care]
  
  # Associations
  belongs_to :shelter
  belongs_to :animal
  belongs_to :parent
  
  has_many :comments, :as => :commentable, :dependent => :destroy
  
  accepts_nested_attributes_for :comments, :allow_destroy => true

  # Validations
  validates_presence_of :animal_id, :message => 'needs to be selected'
  validates_presence_of :placement_type, :in => PLACEMENT_TYPE, :message => 'needs to be selected'
  
  # Scopes
  scope :adopted, includes([:animal, :shelter]).where(:placement_type => :adopted)
  scope :foster_care, includes([:animal, :shelter]).where(:placement_type => :foster_care)
  
end