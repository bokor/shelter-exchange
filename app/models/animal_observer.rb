class AnimalObserver < ActiveRecord::Observer
  
  def after_update(animal)
    if animal.animal_status_id_changed?
      Rails.env.production? ? Delayed::Job.enqueue(Jobs::FacebookLinterJob.new(animal.id)) : animal.logger.debug("FAKE - Facebook Update with Animal ID: #{animal.id}")
    end
  end

end
