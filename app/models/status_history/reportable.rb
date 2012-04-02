module StatusHistory::Reportable
  extend ActiveSupport::Concern
  
  included do

  end
  
  module ClassMethods
  
    def by_month(range)
      self.select([:id, :animal_id]).where(:created_at => range).reorder("animal_id, created_at DESC").uniq(&:animal_id)
    end
  
    def status_by_month_year(month, year, state=nil)
      start_date = (month.blank? or year.blank?) ? Date.today : Date.civil(year.to_i, month.to_i, 01)
      range = start_date.beginning_of_month..start_date.end_of_month    
    
      scope = scoped{}
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
  
    def totals_by_month(year, status, with_type=false)
      start_date = year.blank? ? Date.today.beginning_of_year : Date.parse("#{year}0101").beginning_of_year
      end_date = year.blank? ? Date.today.end_of_year : Date.parse("#{year}0101").end_of_year
      scope = scoped{}
    
      if with_type
        scope = scope.select("animal_types.name as type").joins(:animal => :animal_type).group(:animal_type_id)
      else
        scope = scope.select("'Total' as type")
      end
    
      start_date.month.upto(end_date.month) do |month|
        scope = scope.select("COUNT(CASE WHEN status_histories.created_at BETWEEN '#{start_date.beginning_of_month}' AND '#{start_date.end_of_month}' THEN 1 END) AS #{Date::MONTHNAMES[month].downcase}")
        start_date = start_date.next_month
      end
      scope = scope.where(:animal_status_id => AnimalStatus::STATUSES[status]) unless status.blank?
      scope = scope.reorder(nil).limit(nil)
      scope
    end

  end
  
end

