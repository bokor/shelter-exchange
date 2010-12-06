module ReportsHelper
  
  def status_by_current_year
   Animal.unscoped.joins(:animal_status).where(:shelter_id => @current_shelter.id, :status_change_date => Date.today.beginning_of_year..Date.today.end_of_year ).count(:select => "animal_statuses.name, count(animals.animal_status_id)", :group => "animal_statuses.name")
  end  
  
  def status_by_current_month
   Animal.unscoped.joins(:animal_status).where(:shelter_id => @current_shelter.id, :status_change_date => Date.today.beginning_of_month..Date.today.end_of_month ).count(:select => "animal_statuses.name, count(animals.animal_status_id)", :group => "animal_statuses.name")
  end
  
end
