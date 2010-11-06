class Note < ActiveRecord::Base
  default_scope :order => 'created_at DESC'
   
  # Associations
  belongs_to :notable, :polymorphic => true
  belongs_to :note_category, :readonly => true
   
  # Validations
  validates_presence_of :title
  validates_presence_of :note_category_id
   
  # Callbacks

  # Scopes
  # scope :general, lambda {{ :conditions => ['note_category_id = ?', 1] }}
  #   scope :medical, lambda {{ :conditions => ['note_category_id = ?', 2] }}
  #   scope :behavior, lambda {{ :conditions => ['note_category_id = ?', 3] }}
  
  # JOINS AND INNER JOINS
  # scope :animal_filter, lambda {|name| joins(:note_category).where('note_categories.name = ?', name) }
  # TWO LIGHT QUERIES
  scope :animal_filter, lambda {|name| where('note_category_id = ?', NoteCategory.find_by_name(name).id) }
  
end
