class AnimalObserver < ActiveRecord::Observer

  def after_update(animal)
    if animal.animal_status_id_changed?
      if Rails.env.production?
        Delayed::Job.enqueue(ShelterExchange::Jobs::FacebookLinterJob.new(animal.id))
      else
        animal.logger.debug("FAKE - Facebook Update with Animal ID: #{animal.id}")
      end
    end
  end

  def after_save(animal)
    if [animal.animal_status_id_was, animal.animal_status_id].any? { |status| AnimalStatus::AVAILABLE.include?(status) }
      enqueue_integrations(animal.shelter.id)
    end
  end

  private

  def enqueue_integrations(shelter_id)
    Integration.where(:shelter_id => shelter_id).each do |integration|
      case integration.class.to_sym
      when :petfinder
        Delayed::Job.enqueue(ShelterExchange::Jobs::PetfinderJob.new(shelter_id))
      when :adopt_a_pet
        Delayed::Job.enqueue(ShelterExchange::Jobs::AdoptAPetJob.new(shelter_id))
      end
    end
  end
end

