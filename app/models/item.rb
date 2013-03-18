class Item < ActiveRecord::Base

  # Associations
  #----------------------------------------------------------------------------
  belongs_to :shelter, :readonly => true
end
