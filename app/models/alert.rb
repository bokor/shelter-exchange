class Alert < ActiveRecord::Base
  
  SUBJECT_TYPE = { :animal => "Animal" }
  
  # Associations
  belongs_to :animal, :foreign_key => "subject_id"
  belongs_to :alert_type, :readonly => true
  
  # Validations
  validates_presence_of :title
  validates_presence_of :alert_type_id, :message => 'needs to be selected'
  validates_presence_of :description
  
  # Callbacks
  
  # Scopes
end
