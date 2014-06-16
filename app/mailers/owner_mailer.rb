class OwnerMailer < ActionMailer::Base
  helper :url

  default :from => "ShelterExchange <do-not-reply@shelterexchange.org>",
          :content_type => "text/html"

  def account_created(account, shelter, user)
    @account = account
    @shelter = shelter
    @user = user
    mail(:to => "application@shelterexchange.org",
         :subject => "Shelter Exchange [#{Rails.env}] - A new account has been created (#{shelter.name})")
  end

  def revoked_integration(integration)
    @integration = integration
    @shelter = integration.shelter

    mail(
      to: "application@shelterexchange.org",
      subject: "Auto Upload Error - #{@shelter.name}(#{@shelter.id})"
    )
  end
end


