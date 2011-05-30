class TransferObserver < ActiveRecord::Observer
  
  def after_create(transfer)
    transfer_request_notification(transfer)
  end
  
  def after_save(transfer)
    send("#{transfer.status}_notification", transfer) unless transfer.new_record? or transfer.new_request?
  end
  
  
  private
    
    def transfer_request_notification(transfer)
      TransferMailer.delay.requestor_new_request(transfer)
      TransferMailer.delay.requestee_new_request(transfer, transfer.transfer_history_reason)
    end
    
    def approved_notification(transfer)
      TransferMailer.delay.approved(transfer, transfer.transfer_history_reason)
    end
    
    def rejected_notification(transfer)
      TransferMailer.delay.rejected(transfer, transfer.transfer_history_reason)
    end
    
    def completed_notification(transfer)
      TransferMailer.delay.completed(transfer, transfer.transfer_history_reason)
    end
  
end