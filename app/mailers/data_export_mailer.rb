class DataExportMailer < ActionMailer::Base
  default :from => "ShelterExchange <do-not-reply@shelterexchange.org>",
          :content_type => "text/html"

  def completed(shelter)
    @shelter = shelter
    @account = @shelter.account
    email_addresses = @account.users.where(:role => [:owner, :admin]).collect(&:email)
    mail(:to => email_addresses, :subject => "#{@shelter.name}'s export has completed!")
  end

  def failed(shelter)
    @shelter = shelter
    @account = @shelter.account
    email_addresses = @account.users.where(:role => [:owner, :admin]).collect(&:email)
    mail(:to => email_addresses, :subject => "#{@shelter.name}'s export has failed!")
  end
end

