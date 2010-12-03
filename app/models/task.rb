class Task < ActiveRecord::Base
  default_scope :order => 'task.updated_at DESC'
  
  DUE_CATEGORY = { "today" => "Today", 
                   "tomorrow" => "Tomorrow", 
                   "later" => "Later",
                   "specific_date" => "Specific date" }  #:this_week => "This week", :next_week => "Next week",
  
  
  # Associations
  belongs_to :shelter   #, :conditions => {:state => 'active'}
  belongs_to :taskable, :polymorphic => true
  belongs_to :task_category, :readonly => true
  
  # Validations
  validates_presence_of :info
   
  # Callbacks
  
  # Scopes
  # scope :for_global, :include => [:task_category], :conditions => { :taskable_type => nil }
  scope :for_all, includes([:task_category, :taskable])
  
  scope :completed, where(:is_completed => true )
  scope :not_completed, where(:is_completed => false )
  
  scope :overdue, where("due_date < ?", Date.today)
  scope :today, where("due_date = ?", Date.today)
  scope :tomorrow, where("due_date = ?", Date.today + 1.day)
  scope :later, where("due_category = ? OR due_date > ?", 'later', Date.today + 1.day).order("updated_at DESC, due_date DESC")
  
  
end
