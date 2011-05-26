class TransferMailer < ActionMailer::Base
  default :from => "notifier@application.shelterexchange.org"
  
  def request_transfer(transfer)
    # @account = account
    # @shelter = shelter
    # @user = user
    # mail(:from => "New Account Signup - Shelter Exchange<signup@application.shelterexchange.org>", 
    #      :to => "notifications@shelterexchange.org", 
    #      :subject => "A new account has been created (#{shelter.name})")
  end
  
  def approved(transfer)
    # @account = account
    # @shelter = shelter
    # @user = user
    # mail(:from => "New Account Signup - Shelter Exchange<signup@application.shelterexchange.org>", 
    #      :to => "notifications@shelterexchange.org", 
    #      :subject => "A new account has been created (#{shelter.name})")
  end
  
  def rejected(transfer)
    # @account = account
    # @shelter = shelter
    # @user = user
    # mail(:from => "New Account Signup - Shelter Exchange<signup@application.shelterexchange.org>", 
    #      :to => "notifications@shelterexchange.org", 
    #      :subject => "A new account has been created (#{shelter.name})")
  end
  
  def completed(transfer)
    # @account = account
    # @shelter = shelter
    # @user = user
    # mail(:from => "New Account Signup - Shelter Exchange<signup@application.shelterexchange.org>", 
    #      :to => "notifications@shelterexchange.org", 
    #      :subject => "A new account has been created (#{shelter.name})")
  end

end
