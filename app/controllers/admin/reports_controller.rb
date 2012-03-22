class Admin::ReportsController < Admin::ApplicationController
  respond_to :html, :js, :json
  
  def index
  end
  
  def status_by_month_year  
    pie_chart(StatusHistory.status_by_month_year(params[:selected_month], params[:selected_year], params[:selected_state]).all)
  end
  
  def type_by_month_year  
    pie_chart(Animal.type_by_month_year(params[:selected_month], params[:selected_year], nil, params[:selected_state]).all)
  end
  
  def adoptions_monthly_total_by_type
    bar_chart(StatusHistory.totals_by_month(params[:selected_year], :adopted, true).all)
  end
  
  def adoptions_monthly_total
    bar_chart(StatusHistory.totals_by_month(params[:selected_year], :adopted).all)
  end
  
  def euthanized_monthly_total_by_type
    bar_chart(StatusHistory.totals_by_month(params[:selected_year], :euthanized, true).all)
  end
  
  def euthanized_monthly_total
    bar_chart(StatusHistory.totals_by_month(params[:selected_year], :euthanized).all)
  end
  
  def foster_care_monthly_total_by_type
    bar_chart(StatusHistory.totals_by_month(params[:selected_year], :foster_care, true).all)
  end
  
  def foster_care_monthly_total
    bar_chart(StatusHistory.totals_by_month(params[:selected_year], :foster_care).all)
  end
  
  def reclaimed_monthly_total_by_type
    bar_chart(StatusHistory.totals_by_month(params[:selected_year], :reclaimed, true).all)
  end
  
  def reclaimed_monthly_total
    bar_chart(StatusHistory.totals_by_month(params[:selected_year], :reclaimed).all)
  end
  
  def intake_monthly_total_by_type
    bar_chart(Animal.intake_totals_by_month(params[:selected_year], true).all)
  end
  
  def intake_monthly_total
    bar_chart(Animal.intake_totals_by_month(params[:selected_year]).all)
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
