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
  scope :global_includes, :include => [:task_category, :taskable]

  scope :overdue, lambda { { :conditions => ["due_date < ?", Date.today] } }
  scope :today, lambda { { :conditions => ["due_date = ?", Date.today] } }
  scope :tomorrow, lambda { { :conditions => ["due_date = ?", Date.today + 1.day] } }
  scope :later, lambda { { :conditions => ["due_category = ? OR due_date > ?", 'later', Date.today + 1.day], :order => "updated_at DESC, due_date DESC" } }  
  
  
end
