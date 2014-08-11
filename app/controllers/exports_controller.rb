class ExportsController < ApplicationController
  respond_to :csv

  def index
    type_id = params[:exports][:animal_type_id] rescue nil
    status_id = params[:exports][:animal_status_id] rescue nil
    animals = @current_shelter.animals.includes(:animal_type, :animal_status, :photos, :accommodation).reorder(nil)

    # Adding Type and Status Filtering
    animals = animals.where(:animal_type_id => type_id) unless type_id.blank?
    animals = animals.where(:animal_status_id => status_id) unless status_id.blank?

    respond_to do |format|
      format.csv{
        csvfile = CSV.generate{|csv| Animal::ExportPresenter.as_csv(animals, csv) }
        send_data(csvfile, :filename => "#{@current_shelter.name.parameterize}-animals.csv")
      }
    end
  end
end

