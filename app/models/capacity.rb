class Capacity < ActiveRecord::Base
  
   # Associations
   belongs_to :shelter
   belongs_to :animal_type
   
   # Validations
   validates_presence_of :animal_type_id, :message => 'needs to be selected'
   validates_uniqueness_of :animal_type_id, :message => 'already used please edit exisiting'
   validates_numericality_of :max_capacity

   # Scopes

end
