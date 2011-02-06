class ReportsController < ApplicationController
  # before_filter :authenticate_user!
  respond_to :html, :js

  def index
    @active_count = @current_shelter.animals.active.count
    @total_adoptions_month = @current_shelter.animals.current_month.adoptions.count
    @total_euthanized_month = @current_shelter.animals.current_month.euthanized.count
    @total_adoptions_ytd = @current_shelter.animals.year_to_date.adoptions.count
    @total_euthanized_ytd = @current_shelter.animals.year_to_date.euthanized.count
  end
  
  def status_by_current_year
    @statuses = @current_shelter.animals.count_by_status.year_to_date
    render :json => @statuses.collect{ |status| [status.name, status.count ] }
  end
  
  def status_by_current_month
    @statuses = @current_shelter.animals.count_by_status.current_month
    render :json => @statuses.collect{ |status| [status.name, status.count ] }
  end
  
  def type_by_current_year
    @types = @current_shelter.animals.active.count_by_type.year_to_date
    render :json => @types.collect{ |status| [status.name, status.count ] }
  end
  
  def type_by_current_month
    @types = @current_shelter.animals.active.count_by_type.current_month
    render :json => @types.collect{ |status| [status.name, status.count ] }
  end
  
  def total_adoptions_by_type_and_month
    @results = @current_shelter.animals.total_adoptions_type_month
    render :json => @results.collect{ |result| { :type => result.type, :jan => result.jan, :feb => result.feb, :mar => result.mar, :apr => result.apr, :may => result.may, :jun => result.jun, :jul => result.jul, :aug => result.aug, :sept => result.sept, :oct => result.oct, :nov => result.nov, :dec => result.dec } }
  end

end