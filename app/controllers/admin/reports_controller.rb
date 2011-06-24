class Admin::ReportsController < Admin::ApplicationController
  respond_to :html, :js
  
  def index
  end
  
  def status_by_month_year  
    pie_chart(Animal.count_by_status_by_month_year(params[:selected_month], params[:selected_year]))
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
