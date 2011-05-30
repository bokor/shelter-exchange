class Task < ActiveRecord::Base
  default_scope :order => 'updated_at DESC'
  
  # Constants
  DUE_CATEGORY = %w[today tomorrow later specific_date].freeze
  
  # Associations
  belongs_to :shelter, :readonly => true
  belongs_to :taskable, :polymorphic => true
  belongs_to :task_category, :readonly => true
  
  # Validations
  validates :details, :presence => true
  
  # Scopes
  scope :for_all, includes(:task_category, :taskable)
 
  scope :active, where(:completed => false)
  scope :completed, where(:completed => true) 
  
  scope :overdue, where("due_date < ?", Date.today)
  scope :today, where("due_date = ?", Date.today)
  scope :tomorrow, where("due_date = ?", Date.today + 1.day)
  scope :later, where("due_category = ? OR due_date > ?", "later", Date.today + 1.day).order("due_date DESC")
  
  # Scopes - Dashboard Only
  def self.recent_activity(shelter_id, limit=10)
    unscoped.includes(:task_category, :taskable).where(:shelter_id => shelter_id).order("updated_at DESC").limit(limit)
  end
  
end