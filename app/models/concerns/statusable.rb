module Statusable
  extend ActiveSupport::Concern

  included do |base|
    base.scope :active, where(:"#{base.table_name}.animal_status_id" => AnimalStatus::ACTIVE)
    base.scope :non_active, where(:"#{base.table_name}.animal_status_id" => AnimalStatus::NON_ACTIVE)
    base.scope :available, where(:"#{base.table_name}.animal_status_id" => AnimalStatus::AVAILABLE)
    base.scope :for_capacity, where(:"#{base.table_name}.animal_status_id" => AnimalStatus::CAPACITY)
    base.scope :available_for_adoption, where(:"#{base.table_name}.animal_status_id" => AnimalStatus::STATUSES[:available_for_adoption])
    base.scope :adoption_pending, where(:"#{base.table_name}.animal_status_id" => AnimalStatus::STATUSES[:adoption_pending])
    base.scope :adopted, where(:"#{base.table_name}.animal_status_id" => AnimalStatus::STATUSES[:adopted])
    base.scope :foster_care, where(:"#{base.table_name}.animal_status_id" => AnimalStatus::STATUSES[:foster_care])
    base.scope :reclaimed, where(:"#{base.table_name}.animal_status_id" => AnimalStatus::STATUSES[:reclaimed])
    base.scope :euthanized, where(:"#{base.table_name}.animal_status_id" => AnimalStatus::STATUSES[:euthanized])
    base.scope :transferred, where(:"#{base.table_name}.animal_status_id" => AnimalStatus::STATUSES[:transferred])
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

