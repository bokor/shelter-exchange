require "rails_helper"

describe DataExportsController do
  login_user

  describe "GET download" do
    before do
      FOG_BUCKET.files.create(
        :key => "data_export/#{current_shelter.id}.zip",
        :body => open(Rails.root.join("spec/data/documents/testing.zip")).read,
        :public => false,
        :content_type => Mime::ZIP
      )
    end

    it "responds successfully" do
      get :download, :format => :zip
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "downloads zip file" do
      get :download, :format => :zip
      expect(response.headers["Content-Type"]).to eq("application/zip")
      expect(response.headers["Content-Disposition"]).to eq("attachment; filename=\"shelter_exchange_data_export.zip\"")
      expect(response.status).to eq(200)
    end
  end

  describe "POST create" do

    it "redirects to the :setting_path for export_data", :delayed_job => true do
      post :create
      expect(response).to redirect_to(setting_path(:tab => :export_data))
    end

    it "created a new generated zip file export", :delayed_job => true do
      Timecop.freeze(Time.parse("Mon, 12 May 2014"))
      base_dir = File.join(Rails.root, "tmp", "data_export")
      write_dir = File.join(base_dir, "#{current_shelter.id}")
      post :create

      job = YAML.load(Delayed::Job.last.handler)
      expect(Delayed::Job.last.name).to eq("DataExportJob")
      expect(job.class).to eq(DataExportJob)
      expect(job.instance_variable_get(:@shelter_id)).to eq(current_shelter.id)
      expect(job.instance_variable_get(:@base_dir)).to eq(base_dir)
      expect(job.instance_variable_get(:@write_dir)).to eq(write_dir)
    end

    it "sets the flash message", :delayed_job => true do
      post :create
      expect(flash[:notice]).to eq("Export started! An email will be sent to #{current_user.email} when it has completed.")
    end
  end
end

