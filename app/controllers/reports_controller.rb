class ReportsController < ApplicationController
  respond_to :html, :js, :json

  def index
    @active_count_month = @current_shelter.animals.current_month.active.count
    @total_adoptions_month = @current_shelter.animals.current_month.adoptions.count
    @total_euthanized_month = @current_shelter.animals.current_month.euthanized.count
    @active_count_ytd = @current_shelter.animals.year_to_date.active.count
    @total_adoptions_ytd = @current_shelter.animals.year_to_date.adoptions.count
    @total_euthanized_ytd = @current_shelter.animals.year_to_date.euthanized.count
  end

  def status_by_current_month
    pie_chart(@current_shelter.animals.count_by_status.current_month)
  end
  
  def type_by_current_month
    pie_chart(@current_shelter.animals.active.count_by_type.current_month)
  end
    
  def adoptions_monthly_total_by_type
    bar_chart(@current_shelter.animals.totals_by_month(params[:selected_year], :status_change_date, true).adoptions)
  end
  
  def adoptions_monthly_total
    bar_chart(@current_shelter.animals.totals_by_month(params[:selected_year], :status_change_date).adoptions)
  end
  
  def euthanized_monthly_total_by_type
    bar_chart(@current_shelter.animals.totals_by_month(params[:selected_year], :status_change_date, true).euthanized)
  end
  
  def euthanized_monthly_total
    bar_chart(@current_shelter.animals.totals_by_month(params[:selected_year], :status_change_date).euthanized)
  end
  
  def foster_care_monthly_total_by_type
    bar_chart(@current_shelter.animals.totals_by_month(params[:selected_year], :status_change_date, true).foster_care)
  end
  
  def foster_care_monthly_total
    bar_chart(@current_shelter.animals.totals_by_month(params[:selected_year], :status_change_date).foster_care)
  end
  
  def reclaimed_monthly_total_by_type
    bar_chart(@current_shelter.animals.totals_by_month(params[:selected_year], :status_change_date, true).reclaimed)
  end
  
  def reclaimed_monthly_total
    bar_chart(@current_shelter.animals.totals_by_month(params[:selected_year], :status_change_date).reclaimed)
  end
  
  def intake_monthly_total_by_type
    bar_chart(@current_shelter.animals.totals_by_month(params[:selected_year], :created_at, true).active)
  end
  
  def intake_monthly_total
    bar_chart(@current_shelter.animals.totals_by_month(params[:selected_year], :created_at).active)
  end
  
  def pie_chart(results)
    respond_to do |format|
      format.html
      format.json {
        render :json => results.collect{ |result| { :name => result.name, :count => result.count } }
      }
    end
  end
  
  def bar_chart(results)
    respond_to do |format|
      format.html
      format.json {
        render :json => results.collect{ |result| { :type => result.type, :jan => result.jan, :feb => result.feb, :mar => result.mar, :apr => result.apr, :may => result.may, :jun => result.jun, :jul => result.jul, :aug => result.aug, :sep => result.sep, :oct => result.oct, :nov => result.nov, :dec => result.dec } }
      }
    end
  end

end

#  Might be a way to do this dynamically
#  /reports/:type/:year/:name/     :type = pie_chart or :bar_chart  :name = status_by_current_year (move into model)
#  /reports/:type/:name/?selected_year=
#

#
#   send("pie_chart",@current_shelter.animals.send("count_by_status"))
#

