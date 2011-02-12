class Capacity < ActiveRecord::Base
  
  # Associations
  belongs_to :shelter
  belongs_to :animal_type
   
  # Validations
  validates :animal_type_id, :presence => { :message => 'needs to be selected' },
                             :uniqueness => { :scope => :shelter_id, :message => 'already used please edit exisiting' }
  validates_numericality_of :max_capacity

  # Scopes

end
