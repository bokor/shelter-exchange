class ReportsController < ApplicationController
  respond_to :html, :js, :json

  def index
    @current_counts = @current_shelter.animals.count_by_status.active
    @status_counts = @current_shelter.status_histories.status_counts(3).all
  end

  def custom
    respond_to do |format|
      format.html
      format.json {
        selected_year = params[:selected_year] || Time.zone.today.year
        status = params[:status].to_sym rescue nil
        by_type = params[:by_type].to_boolean rescue false
        results = @current_shelter.status_histories.totals_by_month(selected_year, status, by_type)

        render :json => results.collect{ |result| { :type => result.type, :jan => result.january.to_i, :feb => result.february.to_i, :mar => result.march.to_i, :apr => result.april.to_i, :may => result.may.to_i, :jun => result.june.to_i, :jul => result.july.to_i, :aug => result.august.to_i, :sep => result.september.to_i, :oct => result.october.to_i, :nov => result.november.to_i, :dec => result.december.to_i } }.to_json
      }
    end
  end

  def status_by_month_year
    respond_to do |format|
      format.html
      format.json {
        results = @current_shelter.status_histories.status_by_month_year(params[:selected_month], params[:selected_year]).all
        render :json => results.collect{ |result| { :name => result.name, :count => result.count.to_i } }.to_json
      }
    end
  end

  def type_by_month_year
    respond_to do |format|
      format.html
      format.json {
        results = @current_shelter.animals.type_by_month_year(params[:selected_month], params[:selected_year], @current_shelter.id)
        render :json => results.collect{ |result| { :name => result.name, :count => result.count.to_i } }.to_json
      }
    end
  end
end

