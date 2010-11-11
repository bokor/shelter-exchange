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
  # scope :for_animals, :include => [:task_category, :taskable], :conditions => { :taskable_type => "Animal" }

  scope :overdue, lambda { { :include => [:task_category, :taskable], :conditions => ["due_date < ?", Date.today] } }
  scope :today, lambda { { :include => [:task_category, :taskable], :conditions => ["due_date = ?", Date.today] } }
  scope :tomorrow, lambda { { :include => [:task_category, :taskable], :conditions => ["due_date = ?", Date.today + 1.day] } }
  # scope :this_week, lambda { { :include => [:task_category, :taskable], :conditions => ["strftime('%W',due_date) = ? AND NOT due_date <= ?", (Date.today + 1.day).strftime('%W'), Date.today] } }
  # scope :next_week, lambda { { :include => [:task_category, :taskable], :conditions => ["strftime('%W',due_date + '1 week') = ?", (Date.today + 1.day + 1.week).strftime('%W')] } }
  scope :later, lambda { { :include => [:task_category, :taskable], :conditions => ["due_category = ? OR due_date > ?", 'later', Date.today + 1.day], :order => "updated_at DESC, due_date DESC" } }
  
  
end
