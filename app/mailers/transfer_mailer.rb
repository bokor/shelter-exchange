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
    @animal = transfer.animal
    @email_note = email_note
    
    attachments.inline["logo_email.jpg"] = File.read("#{Rails.root}/public/images/logo_email.jpg")
    
    mail(:to => @shelter.email, 
         :subject => "Requested Transfer from #{@requestor_shelter.name} by #{@transfer.requestor}")
  end
  
  def approved(transfer, email_note)
    @transfer = transfer
    @shelter = transfer.shelter
    @animal = transfer.animal
    @email_note = email_note
    
    attachments.inline["logo_email.jpg"] = File.read("#{Rails.root}/public/images/logo_email.jpg")
    
    mail(:to => @transfer.email, 
         :subject => "Transfer Request from #{@shelter.name} for #{@animal.name} - Approved")
  end
  
  def rejected(transfer, email_note)
    @transfer = transfer
    @shelter = transfer.shelter
    @animal = transfer.animal
    @email_note = email_note
    
    attachments.inline["logo_email.jpg"] = File.read("#{Rails.root}/public/images/logo_email.jpg")
    
    mail(:to => @transfer.email, 
         :subject => "Transfer Request from #{@shelter.name} for #{@animal.name} - Rejected")
  end
  
  def completed(transfer, email_note)
    @transfer = transfer
    @shelter = transfer.shelter
    @animal = transfer.animal
    @email_note = email_note
    
    attachments.inline["logo_email.jpg"] = File.read("#{Rails.root}/public/images/logo_email.jpg")
    
    mail(:to => @transfer.email, 
         :subject => "Transfer Request from #{@shelter.name} for #{@animal.name} - Completed")
  end

end
