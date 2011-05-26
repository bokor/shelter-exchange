class AccountObserver < ActiveRecord::Observer
  
  def after_create(account)
    new_account_notification(account)
  end
  
  
  private
    
    def new_account_notification(account)
      AccountMailer.delay.welcome(account,account.shelters.first,account.users.first)
    end

end
