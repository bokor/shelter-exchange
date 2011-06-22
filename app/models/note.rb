class Note < ActiveRecord::Base
  default_scope :order => 'created_at DESC'

  # Constants
  #----------------------------------------------------------------------------  
  DEFAULT_CATEGORY = "general"
  CATEGORIES = %w[general medical behavioral intake].freeze
   
  # Associations
  #----------------------------------------------------------------------------
  belongs_to :shelter, :readonly => true
  belongs_to :notable, :polymorphic => true
   
  # Validations
  #----------------------------------------------------------------------------
  validates :title, :presence => true
  validates :category, :presence => { :in => CATEGORIES, :message => "needs to be selected" }

  # Scopes
  #----------------------------------------------------------------------------
  # scope :animal_filter, lambda {|name| where("category = ?", name) }
  
end
