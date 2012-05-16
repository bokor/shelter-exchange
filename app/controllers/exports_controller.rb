class ExportsController < ApplicationController
  require 'csv'
  respond_to :csv

  def all_animals
    @animals = @current_shelter.animals.includes(:animal_type, :animal_status, :photos).all
    respond_to do |format|       
      format.csv{ send_data(all_animals_csv(@animals), :filename => "#{@current_shelter.name.parameterize}-animals.csv") }
    end
  end
  
  private
    def all_animals_csv(results)
      CSV.generate{|csv| Animal::ExportPresenter.as_csv(results, csv) }
    end
end