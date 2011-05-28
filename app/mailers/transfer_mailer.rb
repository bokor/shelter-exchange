class TransferMailer < ActionMailer::Base
  default :from => "Shelter Exchange<notifier@application.shelterexchange.org>"
  
  def requestor_new_request(transfer)
    @transfer = transfer
    @shelter = transfer.shelter
    @animal = transfer.animal
    attachments.inline["logo_email.jpg"] = File.read("#{Rails.root}/public/images/logo_email.jpg")
    mail(:to => @transfer.email, 
         :subject => "Requested Transfer from #{@shelter.name}")
        
  end
  
  def requestee_new_request(transfer, email_note)
    @transfer = transfer
    @shelter = transfer.shelter
    @requestor_shelter = transfer.requestor_shelter
    # @account = @shelter.account
    @animal = transfer.animal
    @email_note = email_note
    attachments.inline["logo_email.jpg"] = File.read("#{Rails.root}/public/images/logo_email.jpg")
    mail(:to => @shelter.email, 
         :subject => "Requested Transfer from #{@requestor_shelter.name} by #{@transfer.requestor}")
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
