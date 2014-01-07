class AccountMailer < ActionMailer::Base
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

  def welcome(account, shelter, user)
    @account = account
    @shelter = shelter
    @user = user
    attachments.inline["logo_email.jpg"] = File.read(Rails.application.assets.find_asset('logo_email.jpg'))

    mail(:to => @user.email, :subject => "Welcome to Shelter Exchange!")
  end
end

