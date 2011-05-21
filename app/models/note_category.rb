class NoteCategory < ActiveRecord::Base
  
  # Associations
  has_many :notes, :readonly => true
  
end
