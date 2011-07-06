class Task < ActiveRecord::Base
  default_scope :order => 'due_date ASC, updated_at DESC'
  
  # Constants
  #----------------------------------------------------------------------------
  CATEGORIES = %w[call email follow-up meeting to-do educational behavioral medical].freeze
  DUE_CATEGORIES = %w[today tomorrow later specific_date].freeze
  
  # Associations
  #----------------------------------------------------------------------------
  belongs_to :shelter, :readonly => true
  belongs_to :taskable, :polymorphic => true
  
  # Validations
  #----------------------------------------------------------------------------
  validates :details, :presence => true
  
  # Scopes
  #----------------------------------------------------------------------------
  scope :active, where(:completed => false)
  scope :completed, where(:completed => true) 
  
  scope :overdue, where("due_date < ?", Date.today) # ??? Time.zone.now.midnight.to_date
  scope :today, where("due_date = ?", Date.today)
  scope :tomorrow, where("due_date = ?", Date.today + 1.day)
  scope :later, where("due_category = ? OR due_date > ?", "later", Date.today + 1.day).order("due_date DESC")
  
  # Scopes - Dashboard Only - Recent Activity
  #----------------------------------------------------------------------------
  def self.recent_activity(shelter_id, limit=10)
    unscoped.includes(:taskable).where(:shelter_id => shelter_id).order("updated_at DESC").limit(limit)
  end
  
  # Return a map when the key is category type id as a string
  # and the value is an array of arrays, each entry having 
  # the first value as the category path and the second value
  # being the category id as a string
  # def self.all_groups
  #   all.inject(Hash.new([])) do |map, due_section| 
  #     map[due_section] = task
  #     map
  #   end
  # end

  # Instance Methods
  #----------------------------------------------------------------------------  
  def completed?
    self.completed
  end
  
  def overdue?
    self.due_date.present? and self.due_date < Date.today
  end
  
  def today?
    self.due_date.present? and self.due_date == Date.today
  end
  
  def tomorrow?
    self.due_date.present? and self.due_date == Date.today + 1.day
  end
  
  def later?
    self.due_date.blank? or self.due_date > Date.today + 1.day or self.due_category == "later"
  end
  
  def specific_date?
    self.due_category == "specific_date"
  end
  
  def due_section
    due_section = self.due_category
    if self.later?
      due_section = "later"
    elsif self.overdue?
      due_section = "overdue"
    elsif self.today?
      due_section = "today"
    elsif self.tomorrow?
      due_section = "tomorrow"
    end
  end
  
end