class Announcement < ActiveRecord::Base
  
  # Constants
  #----------------------------------------------------------------------------
  CATEGORIES = %w[software_update general_notification].freeze
 
  # Validations
  #----------------------------------------------------------------------------
  validates :title, :presence => true
  validates :message, :presence => true
  validates :category, :presence => { :in => CATEGORIES }
  validates :starts_at, :presence => true
  validates :ends_at, :presence => true

  # Scopes
  #----------------------------------------------------------------------------
  scope :active, where("starts_at <= ? AND ends_at >= ?", Time.now.utc, Time.now.utc)
  scope :since, lambda { |hide_time| where("updated_at > ? OR starts_at > ?", hide_time.to_time.utc, hide_time.to_time.utc) if hide_time }
  
  # Class Methods
  #---------------------------------------------------------------------------- 
  def self.current_announcements(hide_time)
    active.since(hide_time)
  end
    
end