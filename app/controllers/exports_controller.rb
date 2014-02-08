require 'csv'

class ExportsController < ApplicationController
  respond_to :csv

  def all_animals
    @animals = @current_shelter.animals.includes(:animal_type, :animal_status, :photos).all

    respond_to do |format|
      format.csv{
        csvfile = CSV.generate{|csv| Animal::ExportPresenter.as_csv(@animals, csv) }
        send_data(csvfile, :filename => "#{@current_shelter.name.parameterize}-animals.csv")
      }
    end
  end
end

