module TransfersHelper
  
  def status_action_name(transfer)
    if transfer.approved?
      "Approve"
    elsif transfer.completed?
      "Complete"
    elsif transfer.rejected?
      "Reject"
    end
  end
  
end
