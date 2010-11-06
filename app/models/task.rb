class Task < ActiveRecord::Base
  default_scope :order => 'created_at DESC'
  
  DUE_CATEGORY = { "Today" => :today, 
                   "Tomorrow" => :tomorrow, 
                   "This week" => :this_week,
                   "Next week" => :next_week,
                   "Later" => :later,
                   "Specific date" => :specific_date }
  
  
  # Associations
  belongs_to :taskable, :polymorphic => true
  belongs_to :task_category, :readonly => true
  
  # Validations
  validates_presence_of :info
  # validates_presence_of :task_category_id, :message => 'needs to be selected'
   
  # Callbacks
  
  # Scopes

end
