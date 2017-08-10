class DataExportsController < ApplicationController

  def download
    export_filename = "#{@current_shelter.id}-#{@current_shelter.name.parameterize.dasherize}.zip"
    data_export_data = FOG_BUCKET.files.get("data_export/#{export_filename}").body

    respond_to do |format|
      format.zip {
        send_data(data_export_data, :type => Mime::ZIP, :filename => export_filename)
      }
    end
  end

  def create
    Delayed::Job.enqueue(DataExportJob.new(@current_shelter.id))
    flash[:notice] = "Export started! An email will be sent to #{current_user.email} when it has completed."
    redirect_to setting_path(:tab => :export_data)
  end
end

