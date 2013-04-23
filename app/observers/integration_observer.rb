class IntegrationObserver < ActiveRecord::Observer

  def after_save(integration)
    case integration.class.to_sym
    when :petfinder
      Delayed::Job.enqueue(ShelterExchange::Jobs::PetfinderJob.new(integration.shelter_id))
    when :adopt_a_pet
      Delayed::Job.enqueue(ShelterExchange::Jobs::AdoptAPetJob.new(integration.shelter_id))
    end
  end
end


