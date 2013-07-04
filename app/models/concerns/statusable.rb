module Statusable
  extend ActiveSupport::Concern

  module ClassMethods
    def active
      where(:"#{self.table_name}.animal_status_id" => AnimalStatus::ACTIVE)
    end

    def non_active
      where(:"#{self.table_name}.animal_status_id" => AnimalStatus::NON_ACTIVE)
    end

    def available
      where(:"#{self.table_name}.animal_status_id" => AnimalStatus::AVAILABLE)
    end

    def for_capacity
      where(:"#{self.table_name}.animal_status_id" => AnimalStatus::CAPACITY)
    end

    def available_for_adoption
      where(:"#{self.table_name}.animal_status_id" => AnimalStatus::STATUSES[:available_for_adoption])
    end

    def adoption_pending
      where(:"#{self.table_name}.animal_status_id" => AnimalStatus::STATUSES[:adoption_pending])
    end

    def adopted
      where(:"#{self.table_name}.animal_status_id" => AnimalStatus::STATUSES[:adopted])
    end

    def foster_care
      where(:"#{self.table_name}.animal_status_id" => AnimalStatus::STATUSES[:foster_care])
    end

    def reclaimed
      where(:"#{self.table_name}.animal_status_id" => AnimalStatus::STATUSES[:reclaimed])
    end

    def euthanized
      where(:"#{self.table_name}.animal_status_id" => AnimalStatus::STATUSES[:euthanized])
    end

    def transferred
      where(:"#{self.table_name}.animal_status_id" => AnimalStatus::STATUSES[:transferred])
    end
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

