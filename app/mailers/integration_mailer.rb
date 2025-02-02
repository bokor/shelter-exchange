class IntegrationMailer < ActionMailer::Base
  helper :url

  default :from => "ShelterExchange <do-not-reply@shelterexchange.org>",
          :content_type => "text/html"

  def revoked(integration)
    @integration = integration
    @shelter = integration.shelter
    @account = integration.shelter.account

    mail_to = [
      @account.users.collect(&:email),
      @shelter.email
    ].flatten.join(",")

    attachments.inline["logo_email.jpg"] = File.read(Rails.application.assets.find_asset('logo_email.jpg'))

    mail(
      to: mail_to,
      subject: "Your Shelter Exchange Auto Upload is no longer working"
    )
  end
end

