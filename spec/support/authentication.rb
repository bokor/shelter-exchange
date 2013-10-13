module Authentication
  module Controller
    def login_owner
      let(:current_owner) { Owner.gen }

      before do
        @request.env["devise.mapping"] = Devise.mappings[:owner]
        sign_in current_owner
      end
    end

    def login_user
      let(:current_account) { Account.gen }
      let(:current_user) { current_account.users.first }
      let(:current_shelter) { current_account.shelters.first }

      before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        @request.host = "#{current_account.subdomain}.#{Rails.application.routes.default_url_options[:host]}"

        sign_in current_user
      end
    end
  end

  module Request
    def login_user
      let(:current_account) { Account.gen }
      let(:current_user) { current_account.users.first }
      let(:current_shelter) { current_account.shelters.first }

      before do
        switch_to_subdomain(current_account.subdomain)
        login_as(current_user, :scope => :user)
      end
    end
  end
end

