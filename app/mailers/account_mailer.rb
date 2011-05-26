class AccountMailer < ActionMailer::Base
  default :from => "notifier@application.shelterexchange.org"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.account.confirmation.subject
  #
  def welcome(account, shelter, user)
    @account = account
    @shelter = shelter
    @user = user
    mail(:from => "New Account Signup - Shelter Exchange<signup@application.shelterexchange.org>", 
         :to => "notifications@shelterexchange.org", 
         :subject => "A new account has been created (#{shelter.name})")
  end


end
