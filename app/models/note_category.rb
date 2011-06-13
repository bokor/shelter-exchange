class NoteCategory < ActiveRecord::Base
  
  # Associatons
  #----------------------------------------------------------------------------
  has_many :notes, :readonly => true
  
end
