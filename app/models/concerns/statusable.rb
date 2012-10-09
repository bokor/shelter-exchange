module Statusable
  extend ActiveSupport::Concern
  
  included do
    
    scope :active, where(:animal_status_id => AnimalStatus::ACTIVE)
    scope :non_active, where(:animal_status_id => AnimalStatus::NON_ACTIVE)
    scope :available, where(:animal_status_id => AnimalStatus::AVAILABLE)
    scope :available_for_adoption, where(:animal_status_id => AnimalStatus::STATUSES[:available_for_adoption])
    scope :adoption_pending, where(:animal_status_id => AnimalStatus::STATUSES[:adoption_pending])
    scope :adopted, where(:animal_status_id => AnimalStatus::STATUSES[:adopted])
    scope :foster_care, where(:animal_status_id => AnimalStatus::STATUSES[:foster_care])
    scope :reclaimed, where(:animal_status_id => AnimalStatus::STATUSES[:reclaimed])
    scope :euthanized, where(:animal_status_id => AnimalStatus::STATUSES[:euthanized])
    scope :transferred, where(:animal_status_id => AnimalStatus::STATUSES[:transferred])
    
  end
  
  def available?
    AnimalStatus::AVAILABLE.include?(self.animal_status_id)
  end
  
  def available_for_adoption?
    self.animal_status_id == AnimalStatus::STATUSES[:available_for_adoption]
  end
  
  def adopted?
    self.animal_status_id == AnimalStatus::STATUSES[:adopted]
  end
  
  def adoption_pending?
    self.animal_status_id == AnimalStatus::STATUSES[:adoption_pending]
  end
  
  def reclaimed?
    self.animal_status_id == AnimalStatus::STATUSES[:reclaimed]
  end
  
  def foster_care?
    self.animal_status_id == AnimalStatus::STATUSES[:foster_care]
  end
  
  def deceased?
    self.animal_status_id == AnimalStatus::STATUSES[:deceased]
  end
  
  def euthanized?
    self.animal_status_id == AnimalStatus::STATUSES[:euthanized]
  end
  
  def transferred?
    self.animal_status_id == AnimalStatus::STATUSES[:transferred]
  end

end
