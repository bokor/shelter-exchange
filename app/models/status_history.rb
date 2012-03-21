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
  
  def self.status_by_month_year(month, year, shelter_id=nil)
    start_date = (month.blank? or year.blank?) ? Date.today : Date.civil(year.to_i, month.to_i, 01)
    range = start_date.beginning_of_month..start_date.end_of_month    
    scope = scoped{}
    scope = scope.select("count(*) count, animal_statuses.name")
    scope = scope.joins(:animal_status)
    scope = scope.where(:status_histories => { :id => self.by_month(range, shelter_id).all })
    scope = scope.group("status_histories.animal_status_id").reorder(nil).limit(nil)
    scope
  end
  
  def self.by_month(range, shelter_id)
    status_histories_order = self.select(:id).where(:created_at => range).where(:shelter_id => shelter_id||{}).reorder("animal_id, created_at DESC").all
    scope = scoped{}
    scope = scope.select(:id).where(:id => status_histories_order)
    scope = scope.where(:shelter_id => shelter_id) unless shelter_id.blank?
    scope = scope.group(:animal_id)
    scope
  end

end
