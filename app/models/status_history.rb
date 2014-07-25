class StatusHistory < ActiveRecord::Base
  default_scope :order => "status_histories.status_date DESC, status_histories.created_at DESC"

  # Associations
  #----------------------------------------------------------------------------
  belongs_to :shelter, :readonly => true
  belongs_to :animal, :readonly => true
  belongs_to :animal_status, :readonly => true
  belongs_to :contact, :readonly => true

  # Class Methods
  #----------------------------------------------------------------------------
  def self.create_with(shelter_id, animal_id, animal_status_id, date, reason)
    create!({
      :shelter_id => shelter_id,
      :animal_id => animal_id,
      :animal_status_id => animal_status_id,
      :status_date => date || Time.zone.today,
      :reason => reason
    })
  end

  # Reports
  #----------------------------------------------------------------------------
  def self.by_month(range)
    select([:id, :animal_id]).where(:status_date => range).reorder(nil)
  end

  def self.status_by_month_year(month, year, state=nil)
    start_date = (month.blank? || year.blank?) ? Time.zone.today : Date.parse("#{year}/#{month}/01")
    range = start_date.beginning_of_month..start_date.end_of_month
    status_history_ids = self.by_month(range).collect(&:id)

    scope = self.scoped
    scope = scope.select("count(*) count, animal_statuses.name")
    scope = scope.joins(:animal_status)

    unless state.blank?
      scope = scope.joins(:shelter)
      scope = scope.where(:shelters => { :state => state })
    end

    scope = scope.where(:status_histories => { :id => status_history_ids })
    scope = scope.group("status_histories.animal_status_id").reorder(nil).limit(nil)
    scope
  end

  def self.totals_by_month(year, status, with_type=nil)
    start_date = year.blank? ? Time.zone.today.beginning_of_year : Date.parse("#{year}/01/01").beginning_of_year
    end_date   = year.blank? ? Time.zone.today.end_of_year : Date.parse("#{year}/01/01").end_of_year

    scope = self.scoped

    scope = if with_type
      scope.select("animal_types.name as type").joins(:animal => :animal_type).group(:animal_type_id)
    else
      scope.select("'Total' as type")
    end

    start_date.month.upto(end_date.month) do |month|
      scope = scope.select("COUNT(CASE WHEN status_histories.status_date BETWEEN '#{start_date.beginning_of_month}' AND '#{start_date.end_of_month}' THEN 1 END) AS #{Date::MONTHNAMES[month].downcase}")
      start_date = start_date.next_month
    end

    scope = scope.where(:animal_status_id => AnimalStatus::STATUSES[status])
    scope = scope.reorder(nil).limit(nil)
    scope
  end
  #----------------------------------------------------------------------------

end

