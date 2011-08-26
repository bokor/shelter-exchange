class AccountMailer < ActionMailer::Base
  default :from => "ShelterExchange <do-not-reply@shelterexchange.org>",
          :to => "application@shelterexchange.org"
          

  def account_created(account, shelter, user)
    @account = account
    @shelter = shelter
    @user = user
    mail(:subject => "Shelter Exchange [#{Rails.env}] - A new account has been created (#{shelter.name})")
  end


end
