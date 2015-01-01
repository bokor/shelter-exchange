require "rails_helper"

describe MapsController do
  login_user

  describe "GET overlay" do

    it "responds successfully" do
      get :overlay, :format => :kml
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "assigns @shelters" do
      other_shelter = Shelter.gen

      get :overlay, :format => :kml
      expect(assigns(:shelters)).to match_array([current_shelter, other_shelter])
    end

    it "renders no layout" do
      get :overlay, :format => :kml
      expect(response).to render_template(:layout => false)
    end

    it "renders the :overlay view" do
      expect(controller).to receive(:render_to_string).with('overlay', :format => :kml)

      get :overlay, :format => :kml
      expect(response).to render_template(:overlay)
    end
  end
end

