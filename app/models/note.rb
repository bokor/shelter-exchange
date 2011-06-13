class Note < ActiveRecord::Base
  default_scope :order => 'created_at DESC'
   
  # Associations
  #----------------------------------------------------------------------------
  belongs_to :shelter, :readonly => true
  belongs_to :notable, :polymorphic => true
  belongs_to :note_category, :readonly => true
   
  # Validations
  #----------------------------------------------------------------------------
  validates :title, :presence => true
  validates :note_category_id, :presence => { :message => "needs to be selected" }

  # Scopes
  #----------------------------------------------------------------------------
  scope :animal_filter, lambda {|name| joins(:note_category).where("note_categories.name = ?", name) }
  
end
