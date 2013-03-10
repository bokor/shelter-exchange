module Animal::Transferrable
  extend ActiveSupport::Concern

  included do

  end

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

