class AccountObserver < ActiveRecord::Observer
  
  def after_create(account)
    account_created_notification(account)
  end
  
  
  private
    
    def account_created_notification(account)
      AccountMailer.delay.account_created(account,account.shelters.first,account.users.first)
    end

end
