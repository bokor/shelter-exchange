class Announcement < ActiveRecord::Base
  default_scope :order => 'announcements.created_at DESC'

  # Constants
  #----------------------------------------------------------------------------
  CATEGORIES = %w[general web_update help].freeze

  # Validations
  #----------------------------------------------------------------------------
  validates :title, :presence => true
  validates :message, :presence => true
  validates :category, :inclusion => { :in => CATEGORIES, :message => "needs to be selected" }
  validates :starts_at, :presence => true
  validates :ends_at, :presence => true

  # Scopes
  #----------------------------------------------------------------------------
  scope :active, lambda { |current_time| where("starts_at <= ? AND ends_at >= ?", current_time, current_time) }
  scope :since, lambda { |hide_time| where("updated_at > ? OR starts_at > ?", hide_time.to_time.utc, hide_time.to_time.utc) if hide_time }

  # Class Methods
  #----------------------------------------------------------------------------
  def self.current_announcements(hide_time)
    active(Time.now.utc).since(hide_time)
  end
end

