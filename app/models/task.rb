class Task < ActiveRecord::Base
  default_scope :order => 'updated_at DESC'
  
  DUE_CATEGORY = { "Today" => :today, 
                   "Tomorrow" => :tomorrow, 
                   # "This week" => :this_week,
                   #"Next week" => :next_week,
                   "Later" => :later,
                   "Specific date" => :specific_date }
  
  
  # Associations
  belongs_to :taskable, :polymorphic => true
  belongs_to :task_category, :readonly => true
  
  # Validations
  validates_presence_of :info
   
  # Callbacks
  
  # Scopes
  # scope :for_global, :include => [:task_category], :conditions => { :taskable_type => nil }
  scope :global, :include => [:task_category, :taskable]
  
  scope :completed, :conditions => {"is_completed" => true }
  scope :not_completed, :conditions => {"is_completed" => false }
  
  scope :overdue, :conditions => ["due_date < ?", Date.today]
  scope :today, :conditions => ["due_date = ?", Date.today] 
  scope :tomorrow, :conditions => ["due_date = ?", Date.today + 1.day] 
  scope :later, :conditions => ["due_category = ? OR due_date > ?", 'later', Date.today + 1.day], :order => "updated_at DESC, due_date DESC"  
  
  
end
