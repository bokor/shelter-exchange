class Note < ActiveRecord::Base
  default_scope :order => 'created_at DESC'
   
  # Associations
  belongs_to :shelter
  belongs_to :notable, :polymorphic => true
  belongs_to :note_category, :readonly => true
   
  # Validations
  validates_presence_of :title
  validates_presence_of :note_category_id

  # Scopes
  scope :animal_filter, lambda {|name| joins(:note_category).where('note_categories.name = ?', name) }
  
end
