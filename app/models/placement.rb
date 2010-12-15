class Placement < ActiveRecord::Base
  default_scope :order => 'created_at DESC'
  
  PLACEMENT_TYPE = { :adopted => "Adopted", 
                     :foster_care => "Foster care" }
  
  # Associations
  belongs_to :shelter
  belongs_to :animal
  belongs_to :parent

  # Validations
  validates_presence_of :animal_id, :message => 'needs to be selected'
  validates_presence_of :parent_id, :message => 'needs to be selected'
  validates_presence_of :shelter_id, :message => 'needs to be selected'
  validates_presence_of :placement_type, :in => PLACEMENT_TYPE, :message => 'needs to be selected'
  
  # Scopes
  scope :adopted, includes([:animal, :shelter]).where(:placement_type => 'adopted')
  scope :foster_care, includes([:animal, :shelter]).where(:placement_type => 'foster_care')
  
  # scope :red, where(:colour => 'red')
  #     scope :since, lambda {|time| where("created_at > ?", time) }
  
end