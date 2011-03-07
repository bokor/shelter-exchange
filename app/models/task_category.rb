class TaskCategory < ActiveRecord::Base

  # Associations
  has_many :tasks

end
