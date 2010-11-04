class Note < ActiveRecord::Base
   
  # Associations
  belongs_to :subject, :polymorphic => true
  belongs_to :note_category, :readonly => true
   
  # Validations
  validates_presence_of :title
  validates_presence_of :note_category_id
   
  # Callbacks

  # Scopes
  scope :general, lambda {{ :conditions => ['note_category_id = ?', 1] }}
  scope :medical, lambda {{ :conditions => ['note_category_id = ?', 2] }}
  scope :behavior, lambda {{ :conditions => ['note_category_id = ?', 3] }}
  
end
