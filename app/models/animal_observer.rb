class AnimalObserver < ActiveRecord::Observer
  
  def after_save(animal)
    Delayed::Job.enqueue(Jobs::FacebookLinterJob.new(animal.id)) if Rails.env.production? and animal.status_change_date_changed?
  end

end
