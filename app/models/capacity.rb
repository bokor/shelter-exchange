class Capacity < ActiveRecord::Base

  # Associations
  #----------------------------------------------------------------------------
  belongs_to :shelter, :readonly => true
  belongs_to :animal_type, :readonly => true

  # Validations
  #----------------------------------------------------------------------------
  validates :animal_type_id, :presence => { :message => "needs to be selected" },
                             :uniqueness => { :scope => :shelter_id, :message => "is already in use" }
  validates :max_capacity, :numericality => true

  # Instance Methods
  #----------------------------------------------------------------------------
  def animal_count(current_shelter)
    self.animal_type.animals.active.where(:shelter_id => current_shelter).limit(nil).count
  end
end
