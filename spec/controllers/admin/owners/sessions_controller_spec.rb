require "rails_helper"

describe Admin::Owners::SessionsController do
  login_owner

  controller(Admin::Owners::SessionsController) do
    def after_sign_up_path_for(resource_or_scope)
      super resource_or_scope
    end

    def after_sign_out_path_for(resource_or_scope)
      super resource_or_scope
    end
  end

  describe "METHOD after_sign_in_path_for" do

    it "sets the dashboard path in the session as the sign in path" do
      session[:"owner_return_to"] = nil
      expect(controller.after_sign_in_path_for(current_owner)).to eq(admin_dashboard_index_path)
    end

    it "sets the session value as the sign in path" do
      session[:"owner_return_to"] = "blah/blah"
      expect(controller.after_sign_in_path_for(current_owner)).to eq("blah/blah")
    end
  end

  describe "METHOD after_sign_out_path_for" do

    it "sets the sign_out path" do
      expect(controller.after_sign_out_path_for(current_owner)).to eq(new_owner_session_path)
    end
  end
end

