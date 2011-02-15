class Task < ActiveRecord::Base
  default_scope :order => 'updated_at DESC'
  
  DUE_CATEGORY = %w[today tomorrow later specific_date]  #:this_week => "This week", :next_week => "Next week",
  HUMANIZED_ATTRIBUTES = { :due_category => "When is it due?" }

  
  # Associations
  belongs_to :shelter   #, :conditions => {:state => 'active'}
  belongs_to :taskable, :polymorphic => true
  belongs_to :task_category, :readonly => true
  
  # Validations
  validates_presence_of :details
  validates_presence_of :due_category
   
  # Callbacks
  
  # Scopes
  scope :for_all, includes([:task_category, :taskable])
 
  scope :active, where(:is_completed => false)
  scope :completed, where(:is_completed => true) 
  
  scope :overdue, where("due_date < ?", Date.today)
  scope :today, where("due_date = ?", Date.today)
  scope :tomorrow, where("due_date = ?", Date.today + 1.day)
  scope :later, where("due_category = ? OR due_date > ?", 'later', Date.today + 1.day).order("updated_at DESC, due_date DESC")
  
  private
    def self.human_attribute_name(attr, options = {})
      HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end
  
end
