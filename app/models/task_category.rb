class TaskCategory < ActiveRecord::Base

  # Associations
  #----------------------------------------------------------------------------
  has_many :tasks, :readonly => true

end
