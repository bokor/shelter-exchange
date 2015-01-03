class Task < ActiveRecord::Base
  default_scope :order => "tasks.due_date ASC, tasks.updated_at DESC"

  # Constants
  #----------------------------------------------------------------------------
  CATEGORIES = %w[call email follow-up meeting to-do alert educational behavioral medical].freeze
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

  scope :overdue, where("due_date < ?", Time.zone.now.to_date)
  scope :today, where("due_date = ?", Time.zone.now.to_date)
  scope :tomorrow, where("due_date = ?", Time.zone.now.to_date + 1.day)
  scope :later, where("due_category = ? OR due_date > ?", "later", Time.zone.now.to_date + 1.day).order("due_date DESC")

  # Scopes - Dashboard Only - Recent Activity
  #----------------------------------------------------------------------------
  def self.recent_activity(limit=10)
    includes(:taskable).reorder("tasks.updated_at DESC").limit(limit)
  end

  # Instance Methods
  #----------------------------------------------------------------------------
  def taskable?
    !!self.taskable
  end

  def completed?
    self.completed
  end

  def overdue?
    self.due_date.present? && self.due_date < Time.zone.now.to_date
  end

  def today?
    self.due_date.present? && self.due_date == Time.zone.now.to_date
  end

  def tomorrow?
    self.due_date.present? && self.due_date == Time.zone.now.to_date + 1.day
  end

  def later?
    self.due_date.blank? || self.due_date > Time.zone.now.to_date + 1.day || self.due_category == "later"
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

