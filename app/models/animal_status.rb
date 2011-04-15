class AnimalStatus < ActiveRecord::Base
  
  ACTIVE = [1,3,4,5,6,7,8,9,10,11]
  NON_ACTIVE = [2,12,13,14]
  AVAILABLE_FOR_ADOPTION = 1
  ADOPTED = 2
  FOSTER_CARE = 3
  RECLAIMED = 12
  EUTHANIZED = 14
  
  # Associations
  has_many :animals
  has_many :status_histories, :dependent => :destroy
  
  # Scopes
  scope :active, where(:id => ACTIVE)
  scope :non_active, where(:id => NON_ACTIVE)
  scope :available_for_adoption, where(:id => AVAILABLE_FOR_ADOPTION)
  scope :adopted, where(:id => ADOPTED)
  scope :foster_care, where(:id => FOSTER_CARE)
  scope :reclaimed, where(:id => RECLAIMED)
  scope :euthanized, where(:id => EUTHANIZED)
  
end
