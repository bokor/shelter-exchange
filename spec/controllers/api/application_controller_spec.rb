require "spec_helper"

describe Api::ApplicationController do

  controller(Api::ApplicationController) do
    def index
      render nothing: true
    end
  end

  it "renders current layout" do
    pending "Do not know how to test this. Might be a job for request specs"
  end

  it "assigns @current_shelter" do
    shelter = Shelter.gen :access_token => "access_token"

    get :index, :access_token => "access_token"
    expect(assigns(:current_shelter)).to eq(shelter)
  end

  context "setting CORS headers" do
    it "sets headers when json" do
      get :index, :format => :json
      expect(response.headers["Access-Control-Allow-Origin"]).to eq("*")
      expect(response.headers["Access-Control-Allow-Credentials"]).to eq("true")
      expect(response.headers["Access-Control-Allow-Methods"]).to eq("GET")
      expect(response.headers["Access-Control-Allow-Headers"]).to eq("DNT,X-Mx-ReqToken,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type")
    end

    it "sets headers when xhr" do
      xhr :get, :index
      expect(response.headers["Access-Control-Allow-Origin"]).to eq("*")
      expect(response.headers["Access-Control-Allow-Credentials"]).to eq("true")
      expect(response.headers["Access-Control-Allow-Methods"]).to eq("GET")
      expect(response.headers["Access-Control-Allow-Headers"]).to eq("DNT,X-Mx-ReqToken,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type")
    end

    it "does not set headers when html" do
      get :index, :format => :html
      expect(response.headers["Access-Control-Allow-Origin"]).to be_nil
      expect(response.headers["Access-Control-Allow-Credentials"]).to be_nil
      expect(response.headers["Access-Control-Allow-Methods"]).to be_nil
      expect(response.headers["Access-Control-Allow-Headers"]).to be_nil
    end
  end

  context "responds with error" do

    before do
      Shelter.gen :name => "Cancelled Shelter", :status => "cancelled", :access_token => "access_token"
    end

    it "renders the :index view" do
      get :index, :access_token => "access_token"
      expect(response).to render_template("api/error")
    end

    it "responds with forbidden code" do
      get :index, :access_token => "access_token", :format => :json
      expect(response.status).to eq(403)
    end

    it "renders json error message" do
      get :index, :access_token => "access_token", :format => :json
      expect(MultiJson.load(response.body)).to eq({
        "error" => "Cancelled Shelter's access has been cancelled"
      })
    end
  end
end

