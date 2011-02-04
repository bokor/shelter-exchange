class ReportsController < ApplicationController
  # before_filter :authenticate_user!
  respond_to :html, :js

  def index
    @active_count = @current_shelter.animals.active.count
    @total_adoptions_month = @current_shelter.animals.current_month.total_adoptions.count
    @total_euthanized_month = @current_shelter.animals.current_month.total_euthanized.count
    @total_adoptions_ytd = @current_shelter.animals.year_to_date.total_adoptions.count
    @total_euthanized_ytd = @current_shelter.animals.year_to_date.total_euthanized.count
  end
  
  def status_by_current_year
    @statuses = @current_shelter.animals.group_by_status.year_to_date
    render :json => @statuses.collect{ |status| ["#{status.name}", status.count ] }
  end
  
  def status_by_current_month
    @statuses = @current_shelter.animals.group_by_status.current_month
    render :json => @statuses.collect{ |status| ["#{status.name}", status.count ] }
  end
  
  def type_by_current_year
    @types = @current_shelter.animals.active.group_by_type.year_to_date
    render :json => @types.collect{ |status| ["#{status.name}", status.count ] }
  end
  
  def type_by_current_month
    @types = @current_shelter.animals.active.group_by_type.current_month
    render :json => @types.collect{ |status| ["#{status.name}", status.count ] }
  end

end
