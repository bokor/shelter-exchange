module Animal::Reportable
  extend ActiveSupport::Concern
  
  included do
    
    scope :count_by_type, select("count(*) count, animal_types.name").joins(:animal_type).group(:animal_type_id) 
    scope :count_by_status, select("count(*) count, animal_statuses.name").joins(:animal_status).group(:animal_status_id)
    scope :current_month, where(:status_change_date => Date.today.beginning_of_month..Date.today.end_of_month)
    scope :year_to_date, where(:status_change_date => Date.today.beginning_of_year..Date.today.end_of_year)

  end

  module ClassMethods
    
    def type_by_month_year(month, year, shelter_id=nil, state=nil)
      start_date = (month.blank? or year.blank?) ? Date.today : Date.civil(year.to_i, month.to_i, 01)
      range = start_date.beginning_of_month..start_date.end_of_month    
      status_histories = StatusHistory.where(:shelter_id => shelter_id || {}).by_month(range)
    
      scope = scoped{}
      scope = scope.select("count(*) count, animal_types.name")
      scope = scope.joins(:status_histories, :animal_type)
      unless state.blank?
        scope = scope.joins(:shelter) 
        scope = scope.where(:shelters => { :state => state })
      end
      scope = scope.where(:status_histories => {:id => status_histories})
      scope = scope.where(:animal_status_id => AnimalStatus::ACTIVE)
      scope = scope.group(:animal_type_id)
      scope
    end
  
    def intake_totals_by_month(year, with_type=false)
      start_date = year.blank? ? Date.today.beginning_of_year : Date.parse("#{year}0101").beginning_of_year
      end_date = year.blank? ? Date.today.end_of_year : Date.parse("#{year}0101").end_of_year
      scope = scoped{}
    
      if with_type
        scope = scope.select("animal_types.name as type").joins(:animal_type).group(:animal_type_id)
      else
        scope = scope.select("'Total' as type")
      end
    
      start_date.month.upto(end_date.month) do |month|
        scope = scope.select("COUNT(CASE WHEN animals.created_at BETWEEN '#{start_date.beginning_of_month}' AND '#{start_date.end_of_month}' THEN 1 END) AS #{Date::MONTHNAMES[month].downcase}")
        start_date = start_date.next_month
      end
      scope = scope.reorder(nil).limit(nil)
      scope
    end
    
  end

end

