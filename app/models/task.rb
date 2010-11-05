class Task < ActiveRecord::Base
  
  # Associations
  belongs_to :taskable, :polymorphic => true
  belongs_to :task_category, :readonly => true
  
  # Validations
  validates_presence_of :info
  validates_presence_of :task_category_id, :message => 'needs to be selected'
  
  # Callbacks
  
  # Scopes

end
