class StatusHistoryObserver < ActiveRecord::Observer
  
  def after_save(status_history)
    puts "THIS IS A TEST TO SEE IF THEY AHVE LOADED"
    animal = status_history.animal
    Twitter.update("test tweet #{animal.name}") if animal.available_for_adoption? #and Rails.env.production?
  end

end
