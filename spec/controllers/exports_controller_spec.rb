require "spec_helper"

describe ExportsController do
  login_user

  describe "GET index" do

    it "responds successfully" do
      get :index, :format => :csv
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    context "with no params" do

      before do
        @animal1 = Animal.gen :shelter => current_shelter
        @animal2 = Animal.gen :shelter => current_shelter
      end

      it "sends csv file" do
        csv_string = CSV.generate{|csv| Animal::ExportPresenter.as_csv([@animal1, @animal2], csv) }

        expect(controller).to receive(:send_data).
          with(csv_string, :filename => "#{current_shelter.name.parameterize}-animals.csv").
          and_return { controller.render :nothing => true }

        get :index, :format => :csv
      end
    end

    context "with animal type filter" do

      before do
        @type = AnimalType.gen
        @animal1 = Animal.gen :shelter => current_shelter, :animal_type => @type
        @animal2 = Animal.gen :shelter => current_shelter
      end

      it "sends csv file" do
        csv_string = CSV.generate{|csv| Animal::ExportPresenter.as_csv([@animal1], csv) }

        expect(controller).to receive(:send_data).
          with(csv_string, :filename => "#{current_shelter.name.parameterize}-animals.csv").
          and_return { controller.render :nothing => true }

        get :index, :exports => { :animal_type_id => @type.id, :animal_status_id => "" }, :format => :csv
      end
    end

    context "with animal status filter" do
      before do
        @status = AnimalStatus.gen
        @animal1 = Animal.gen :shelter => current_shelter, :animal_status => @status
        @animal2 = Animal.gen :shelter => current_shelter
      end

      it "sends csv file" do
        csv_string = CSV.generate{|csv| Animal::ExportPresenter.as_csv([@animal1], csv) }

        expect(controller).to receive(:send_data).
          with(csv_string, :filename => "#{current_shelter.name.parameterize}-animals.csv").
          and_return { controller.render :nothing => true }

        get :index, :exports => { :animal_type_id => "", :animal_status_id => @status.id }, :format => :csv
      end
    end

    context "with animal type and status filter" do

      before do
        @type = AnimalType.gen
        @status = AnimalStatus.gen
        @animal1 = Animal.gen :shelter => current_shelter, :animal_status => @status, :animal_type => @type
        @animal2 = Animal.gen :shelter => current_shelter
      end

      it "sends csv file" do
        csv_string = CSV.generate{|csv| Animal::ExportPresenter.as_csv([@animal1], csv) }

        expect(controller).to receive(:send_data).
          with(csv_string, :filename => "#{current_shelter.name.parameterize}-animals.csv").
          and_return { controller.render :nothing => true }

        get :index, :exports => { :animal_type_id => @type.id, :animal_status_id => @status.id }, :format => :csv
      end
    end

  end
end


