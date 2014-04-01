class StatusHistory < ActiveRecord::Base
  default_scope :order => 'status_histories.created_at DESC'

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

  # Reports
  #----------------------------------------------------------------------------
  def self.by_month(range)
    select([:id, :animal_id]).where(:created_at => range).reorder("animal_id, created_at DESC").uniq(&:animal_id).collect(&:id)
  end

  def self.status_by_month_year(month, year, state=nil)
    start_date = (month.blank? or year.blank?) ? Time.zone.now : Date.civil(year.to_i, month.to_i, 01).to_time
    range      = start_date.beginning_of_month..start_date.end_of_month

    scope = self.scoped
    scope = scope.select("count(*) count, animal_statuses.name")
    scope = scope.joins(:animal_status)

    unless state.blank?
      scope = scope.joins(:shelter)
      scope = scope.where(:shelters => { :state => state })
    end

    scope = scope.where(:status_histories => { :id => self.by_month(range) })
    scope = scope.group("status_histories.animal_status_id").reorder(nil).limit(nil)
    scope
  end

  def self.totals_by_month(year, status, with_type=false)
    start_date = year.blank? ? Time.zone.now.beginning_of_year : Date.parse("#{year}0101").to_time.beginning_of_year
    end_date   = year.blank? ? Time.zone.now.end_of_year : Date.parse("#{year}0101").to_time.end_of_year

    scope = self.scoped

    if with_type
      scope = scope.select("animal_types.name as type").joins(:animal => :animal_type).group(:animal_type_id)
    else
      scope = scope.select("'Total' as type")
    end

    start_date.month.upto(end_date.month) do |month|
      scope = scope.select("COUNT(CASE WHEN status_histories.created_at BETWEEN '#{start_date.beginning_of_month}' AND '#{start_date.end_of_month}' THEN 1 END) AS #{Date::MONTHNAMES[month].downcase}")
      start_date = start_date.next_month
    end

    scope = scope.where(:animal_status_id => AnimalStatus::STATUSES[status])
    scope = scope.reorder(nil).limit(nil)
    scope
  end
  #----------------------------------------------------------------------------

end

