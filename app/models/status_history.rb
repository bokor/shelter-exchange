class StatusHistory < ActiveRecord::Base
  default_scope :order => 'created_at DESC'

  # Associations
  belongs_to :shelter, :readonly => true
  belongs_to :animal, :readonly => true
  belongs_to :animal_status, :readonly => true
  
  def self.create_with(shelter_id, animal_id, animal_status_id, reason)
    status_history = StatusHistory.new(:shelter_id => shelter_id, :animal_id => animal_id, :animal_status_id => animal_status_id, :reason => reason)
    status_history.save
  end

end
