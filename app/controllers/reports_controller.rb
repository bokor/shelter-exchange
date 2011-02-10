class ReportsController < ApplicationController
  # load_and_authorize_resource
  respond_to :html, :js, :json

  def index
    @active_count_month = @current_shelter.animals.current_month.active.count
    @total_adoptions_month = @current_shelter.animals.current_month.adoptions.count
    @total_euthanized_month = @current_shelter.animals.current_month.euthanized.count
    @active_count_ytd = @current_shelter.animals.year_to_date.active.count
    @total_adoptions_ytd = @current_shelter.animals.year_to_date.adoptions.count
    @total_euthanized_ytd = @current_shelter.animals.year_to_date.euthanized.count
  end
  
  def status_by_current_year
    respond_to do |format|
      format.html
      format.json {
        @statuses = @current_shelter.animals.count_by_status.year_to_date
        render :json => @statuses.collect{ |status| { :name => status.name, :count => status.count } }
      }
    end
  end
  
  def status_by_current_month
    @statuses = @current_shelter.animals.count_by_status.current_month
    render :json => @statuses.collect{ |status| { :name => status.name, :count => status.count } }
  end
  
  def type_by_current_year
    respond_to do |format|
      format.html
      format.json {
        @types = @current_shelter.animals.active.count_by_type.year_to_date
        render :json => @types.collect{ |type| { :name => type.name, :count => type.count } }
      }
    end
  end
  
  def type_by_current_month
    @types = @current_shelter.animals.active.count_by_type.current_month
    render :json => @types.collect{ |type| { :name => type.name, :count => type.count } }
  end
  
  def adoption_monthly_total_by_type
    respond_to do |format|
      format.html
      format.json {
        @results = @current_shelter.animals.totals_by_month(params[:selected_year], :status_change_date).with_type.adoptions
        render :json => @results.collect{ |result| { :type => result.type, :jan => result.jan, :feb => result.feb, :mar => result.mar, :apr => result.apr, :may => result.may, :jun => result.jun, :jul => result.jul, :aug => result.aug, :sep => result.sep, :oct => result.oct, :nov => result.nov, :dec => result.dec } }
      }
    end
  end
  
  def adoption_monthly_total
    respond_to do |format|
      format.html
      format.json {
        @results = @current_shelter.animals.totals_by_month(params[:selected_year], :status_change_date).adoptions
        render :json => @results.collect{ |result| { :jan => result.jan, :feb => result.feb, :mar => result.mar, :apr => result.apr, :may => result.may, :jun => result.jun, :jul => result.jul, :aug => result.aug, :sep => result.sep, :oct => result.oct, :nov => result.nov, :dec => result.dec } }
      }
    end
  end
  
  def euthanasia_monthly_total_by_type
    respond_to do |format|
      format.html
      format.json {
        @results = @current_shelter.animals.totals_by_month(params[:selected_year], :status_change_date).with_type.euthanized
        render :json => @results.collect{ |result| { :type => result.type, :jan => result.jan, :feb => result.feb, :mar => result.mar, :apr => result.apr, :may => result.may, :jun => result.jun, :jul => result.jul, :aug => result.aug, :sep => result.sep, :oct => result.oct, :nov => result.nov, :dec => result.dec } }
      }
    end
  end
  
  def euthanasia_monthly_total
    respond_to do |format|
      format.html
      format.json {
        @results = @current_shelter.animals.totals_by_month(params[:selected_year], :status_change_date).euthanized
        render :json => @results.collect{ |result| { :jan => result.jan, :feb => result.feb, :mar => result.mar, :apr => result.apr, :may => result.may, :jun => result.jun, :jul => result.jul, :aug => result.aug, :sep => result.sep, :oct => result.oct, :nov => result.nov, :dec => result.dec } }
      }
    end
  end
  
  def intake_monthly_total_by_type
    respond_to do |format|
      format.html
      format.json {
        @results = @current_shelter.animals.totals_by_month(params[:selected_year], :created_at).with_type.active
        render :json => @results.collect{ |result| { :type => result.type, :jan => result.jan, :feb => result.feb, :mar => result.mar, :apr => result.apr, :may => result.may, :jun => result.jun, :jul => result.jul, :aug => result.aug, :sep => result.sep, :oct => result.oct, :nov => result.nov, :dec => result.dec } }
      }
    end
  end
  
  def intake_monthly_total
    respond_to do |format|
      format.html
      format.json {
        @results = @current_shelter.animals.totals_by_month(params[:selected_year], :created_at).active
        render :json => @results.collect{ |result| { :jan => result.jan, :feb => result.feb, :mar => result.mar, :apr => result.apr, :may => result.may, :jun => result.jun, :jul => result.jul, :aug => result.aug, :sep => result.sep, :oct => result.oct, :nov => result.nov, :dec => result.dec } }
      }
    end
  end

end

# def monthly_totals
#   with_scope = params[:with_scope].downcase
#   with_scope == "intake" ? date_type = :created_at : date_type = :status_change_date
# 
#   respond_to do |format|
#     format.html
#     format.json {
#       @results = @current_shelter.animals.totals_by_month(params[:selected_year], date_type)
#       # if params[:with_type]
#       #   render :json => @results.collect{ |result| { :type => result.type, :jan => result.jan, :feb => result.feb, :mar => result.mar, :apr => result.apr, :may => result.may, :jun => result.jun, :jul => result.jul, :aug => result.aug, :sep => result.sep, :oct => result.oct, :nov => result.nov, :dec => result.dec } }
#       # else
#         render :json => @results.collect{ |result| { :jan => result.jan, :feb => result.feb, :mar => result.mar, :apr => result.apr, :may => result.may, :jun => result.jun, :jul => result.jul, :aug => result.aug, :sep => result.sep, :oct => result.oct, :nov => result.nov, :dec => result.dec } }
#       # end
#     }
#   end
# end