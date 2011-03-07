class NoteCategory < ActiveRecord::Base
  
  # Associations
  has_many :notes
  
end
