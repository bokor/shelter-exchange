class ShelterObserver < ActiveRecord::Observer
  
  def after_save(shelter)
    Delayed::Job.enqueue(ShelterExchange::Jobs::MapOverlayJob.new) unless shelter.changes.blank?
  end

end
