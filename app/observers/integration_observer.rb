class IntegrationObserver < ActiveRecord::Observer

  def after_save(integration)
    case integration.to_sym
    when :petfinder
      Delayed::Job.enqueue(PetfinderJob.new(integration.shelter_id))
    when :adopt_a_pet
      Delayed::Job.enqueue(AdoptAPetJob.new(integration.shelter_id))
    end
  end
end


