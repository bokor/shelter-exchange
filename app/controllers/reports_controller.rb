class ReportsController < ApplicationController
  respond_to :html, :js, :json

  def index
    @active_count_month = @current_shelter.animals.current_month.active.count
    @total_adoptions_month = @current_shelter.animals.current_month.adopted.count
    @total_euthanized_month = @current_shelter.animals.current_month.euthanized.count
    @active_count_ytd = @current_shelter.animals.year_to_date.active.count
    @total_adoptions_ytd = @current_shelter.animals.year_to_date.adopted.count
    @total_euthanized_ytd = @current_shelter.animals.year_to_date.euthanized.count
  end

  def status_by_month_year
    pie_chart(@current_shelter.animals.count_by_month_year(:status, params[:selected_month], params[:selected_year], @current_shelter.id).all)
  end
  
  def type_by_month_year
    pie_chart(@current_shelter.animals.count_by_month_year(:type, params[:selected_month], params[:selected_year], @current_shelter.id).all)
  end
    
  def adoptions_monthly_total_by_type
    bar_chart(@current_shelter.animals.totals_by_month(params[:selected_year], :status_change_date, true).adopted.all)
  end
  
  def adoptions_monthly_total
    bar_chart(@current_shelter.animals.totals_by_month(params[:selected_year], :status_change_date).adopted.all)
  end
  
  def euthanized_monthly_total_by_type
    bar_chart(@current_shelter.animals.totals_by_month(params[:selected_year], :status_change_date, true).euthanized.all)
  end
  
  def euthanized_monthly_total
    bar_chart(@current_shelter.animals.totals_by_month(params[:selected_year], :status_change_date).euthanized.all)
  end
  
  def foster_care_monthly_total_by_type
    bar_chart(@current_shelter.animals.totals_by_month(params[:selected_year], :status_change_date, true).foster_care.all)
  end
  
  def foster_care_monthly_total
    bar_chart(@current_shelter.animals.totals_by_month(params[:selected_year], :status_change_date).foster_care.all)
  end
  
  def reclaimed_monthly_total_by_type
    bar_chart(@current_shelter.animals.totals_by_month(params[:selected_year], :status_change_date, true).reclaimed.all)
  end
  
  def reclaimed_monthly_total
    bar_chart(@current_shelter.animals.totals_by_month(params[:selected_year], :status_change_date).reclaimed.all)
  end
  
  def intake_monthly_total_by_type
    bar_chart(@current_shelter.animals.totals_by_month(params[:selected_year], :created_at, true).active.all)
  end
  
  def intake_monthly_total
    bar_chart(@current_shelter.animals.totals_by_month(params[:selected_year], :created_at).active.all)
  end
  
  def pie_chart(results)
    respond_to do |format|
      format.html
      format.json {
        render :json => results.collect{ |result| { :name => result.name, :count => result.count.to_i } }.to_json
      }
    end
  end
  
  def bar_chart(results)
    respond_to do |format|
      format.html
      format.json {
        render :json => results.collect{ |result| { :type => result.type, :jan => result.january.to_i, :feb => result.february.to_i, :mar => result.march.to_i, :apr => result.april.to_i, :may => result.may.to_i, :jun => result.june.to_i, :jul => result.july.to_i, :aug => result.august.to_i, :sep => result.september.to_i, :oct => result.october.to_i, :nov => result.november.to_i, :dec => result.december.to_i } }.to_json
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

