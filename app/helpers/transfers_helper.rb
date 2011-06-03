module TransfersHelper
  
  def status_action_name(transfer)
    case transfer.status
      when "approved"
        "Approve".html_safe
      when "completed"
        "Complete".html_safe
      when "rejected"
        "Reject".html_safe
    end
  end
  
end
