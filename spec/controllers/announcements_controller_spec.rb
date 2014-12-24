require "rails_helper"

describe AnnouncementsController do
  login_user

  describe "POST hide" do
    it "responds successfully" do
      post :hide, :format => :js
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "updates current user announcement hide time" do
      Timecop.freeze(Time.now)

      expect(current_user.announcement_hide_time).to be < Time.now
      post :hide, :format => :js
      expect(current_user.announcement_hide_time.to_i).to eq(Time.now.to_i)
    end
  end
end
