class ShelterObserver < ActiveRecord::Observer
  
  def after_save(shelter)
    Delayed::Job.enqueue MapOverlayJob.new  
  end

end




