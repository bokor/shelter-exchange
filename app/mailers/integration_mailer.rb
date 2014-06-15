class IntegrationMailer < ActionMailer::Base
  helper :url

  default :from => "ShelterExchange <do-not-reply@shelterexchange.org>",
          :content_type => "text/html"

  def revoked_notification(shelter, integration_humanize)
    @shelter = shelter
    @account = shelter.account
    @integration_humanize = integration_humanize

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

  def notify_se_owner(shelter, integration_humanize)
    @shelter = shelter
    @integration_humanize = integration_humanize

    mail(
      to: "application@shelterexchange.org",
      subject: "Auto Upload Error - #{@shelter.name}(#{@shelter.id})"
    )
  end
end

