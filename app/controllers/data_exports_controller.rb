class DataExportsController < ApplicationController

  def download
    file = FOG_BUCKET.files.get("data_export/#{@current_shelter.id}.zip")
    send_data(file.body, :type => "application/zip", :filename => "shelter_exchange_data_export.zip")
  end

  def create
    Delayed::Job.enqueue(DataExportJob.new(@current_shelter.id))
    flash[:notice] = "Export started! An email will be sent to #{current_user.email} when it has completed."
    redirect_to setting_path(:tab => :export_data)
  end
end

