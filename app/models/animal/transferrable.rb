module Animal::Transferrable
  extend ActiveSupport::Concern

  def complete_transfer_request!(current_shelter, requestor_shelter)
    self.animal_status_id = AnimalStatus::STATUSES[:new_intake]
    self.status_history_reason = "Transferred from #{current_shelter.name}"
    self.status_change_date = Date.today
    self.shelter_id = requestor_shelter.id
    self.arrival_date = Date.today
    self.hold_time = nil
    self.euthanasia_date = nil
    self.accommodation_id = nil
    self.touch(:updated_at)
    self.save(:validate => false)
    self.notes.update_all({:shelter_id => requestor_shelter.id})
    # Delete all Records not needed
    self.status_histories.where(:shelter_id => current_shelter.id).delete_all
    self.tasks.delete_all
    self.alerts.delete_all
  end
end

      #animal = self.animal
      #animal.update_attributes({
        #:animal_status_id => AnimalStatus::STATUSES[:new_intake],
        #:status_history_reason => "Transferred from #{shelter.name}",
        #:status_change_date => Date.today,
        #:shelter_id => requestor_shelter.id,
        #:arrival_date => Date.today,
        #:hold_time => nil,
        #:euthanasia_date => nil,
        #:accommodation_id => nil,
        #:updated_at => Date.today
      #})

      ## Update Notes to new Shelter
      #animal.notes.update_all({:shelter_id => requestor_shelter.id})

      ## Delete all Records not needed
      #animal.status_histories.where(:shelter_id => shelter.id).delete_all
      #animal.tasks.delete_all
      #animal.alerts.delete_all

