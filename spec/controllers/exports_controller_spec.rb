require "spec_helper"

describe ExportsController do
  login_user

  describe "GET all_animals" do

    it "responds successfully" do
      get :all_animals, :format => :csv
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @animals" do
      animal = Animal.gen :shelter => current_shelter

      get :all_animals, :format => :csv
      expect(assigns(:animals)).to eq([animal])
    end

    it "sends csv file" do
      animal = Animal.gen :shelter => current_shelter
      csv_string = CSV.generate{|csv| Animal::ExportPresenter.as_csv([animal], csv) }

      expect(controller).to receive(:send_data).
        with(csv_string, :filename => "#{current_shelter.name.parameterize}-animals.csv").
        and_return { controller.render :nothing => true }

      get :all_animals, :format => :csv
    end
  end
end


