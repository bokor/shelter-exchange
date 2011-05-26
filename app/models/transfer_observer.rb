class TransferObserver < ActiveRecord::Observer
  
  def after_create(transfer)
    request_transfer_notification(transfer)
  end
  
  def after_save(transfer)
    if transfer.approved and transfer.completed
      completed_notification(transfer)
    elsif transfer.approved
      approved_notification(transfer)
    end
  end
  
  def after_destroy(transfer)
     rejected_notification(transfer)
  end
  
  
  private
    
    def request_transfer_notification(transfer)
      TransferMailer.delay.request_transfer(transfer)
    end
    
    def approved_notification(transfer)
      TransferMailer.delay.approved(transfer)
    end
    
    def rejected_notification(transfer)
      TransferMailer.delay.rejected(transfer)
    end
    
    def completed_notification(transfer)
      TransferMailer.delay.completed(transfer)
    end
  
end