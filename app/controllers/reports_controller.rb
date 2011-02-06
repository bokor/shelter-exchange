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
  
  #TODO = FIX QUERY TO USE SOMETHING LIKE THIS or Date::MonthNames etc
  #
  # start_date = Date.today.beginning_of_year
  # end_date = Date.today.end_of_year
  # composed_scope = self.scoped
  # composed_scope = composed_scope.select("animal_types.name as type")
  # start_date.month.upto(end_date.month) do |month|
  #   composed_scope = composed_scope.select("COUNT(CASE WHEN status_change_date BETWEEN '#{start_date.beginning_of_month}' AND '#{start_date.end_of_month}' THEN 1 END) AS #{Date::ABBR_MONTHNAMES[month].downcase}")
  #   start_date = start_date.next_month
  # end
  def total_adoptions_by_type_and_month
    @results = @current_shelter.animals.total_adoptions_by_type_and_month
    render :json => @results.collect{ |result| { :type => result.type, :jan => result.jan, :feb => result.feb, :mar => result.mar, :apr => result.apr, :may => result.may, :jun => result.jun, :jul => result.jul, :aug => result.aug, :sep => result.sep, :oct => result.oct, :nov => result.nov, :dec => result.dec } }
  end
  
  def total_adoptions_by_month
    @results = @current_shelter.animals.total_adoptions_by_month
    render :json => @results.collect{ |result| { :jan => result.jan, :feb => result.feb, :mar => result.mar, :apr => result.apr, :may => result.may, :jun => result.jun, :jul => result.jul, :aug => result.aug, :sep => result.sep, :oct => result.oct, :nov => result.nov, :dec => result.dec } }
  end
  
end