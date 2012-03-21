class StatusHistory < ActiveRecord::Base
  default_scope :order => 'created_at DESC'

  # Associations
  #----------------------------------------------------------------------------
  belongs_to :shelter, :readonly => true
  belongs_to :animal, :readonly => true
  belongs_to :animal_status, :readonly => true

  # Class Methods
  #----------------------------------------------------------------------------  
  def self.create_with(shelter_id, animal_id, animal_status_id, reason)
    create!(:shelter_id => shelter_id, :animal_id => animal_id, :animal_status_id => animal_status_id, :reason => reason)
  end
  
  def self.status_by_month_year(month, year)
    start_date = (month.blank? or year.blank?) ? Date.today : Date.civil(year.to_i, month.to_i, 01)
    range = start_date.beginning_of_month..start_date.end_of_month    
    
    scope = scoped{}
    scope = scope.select("count(*) count, animal_statuses.name")
    scope = scope.joins(:animal_status)
    scope = scope.where(:status_histories => { :id => self.by_month(range) })
    scope = scope.group("status_histories.animal_status_id").reorder(nil).limit(nil)
    scope
  end
  
  def self.by_month(range)
    self.select([:id, :animal_id]).where(:created_at => range).reorder("animal_id, created_at DESC").uniq(&:animal_id)
  end

end
