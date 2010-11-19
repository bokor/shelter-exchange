class Notifier < ActionMailer::Base
  default :from => "notifier@application.shelterexchange.org"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.account.confirmation.subject
  #
  def new_account_notification(account,shelter, user)
    @account = account
    @shelter = shelter
    @user = user
    attachments["logo_small.png"] = File.read("#{Rails.root}/public/images/logo_small.png")
    mail(:to => "notifications@shelterexchange.org", :subject => "ShelterExchange - New Account Created (#{shelter.name})")
  end
end

