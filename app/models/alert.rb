class Alert < ActiveRecord::Base
  
  # Associations
  belongs_to :subject, :polymorphic => true
  belongs_to :alert_type, :readonly => true
  
  # Validations
  validates_presence_of :title
  validates_presence_of :alert_type_id, :message => 'needs to be selected'
  validates_presence_of :description
  
  # Callbacks
  
  # Scopes
  
end
