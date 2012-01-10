class AccountObserver < ActiveRecord::Observer
  
  def after_create(account)
    account_created_notification(account)
    welcome_notification(account)
  end
  
  
  private
    
    def account_created_notification(account)
      AccountMailer.delay.account_created(account,account.shelters.first,account.users.first)
    end
    
    def welcome_notification(account)
      run_at = Rails.env.production? ? 1.hour.from_now : Time.zone.now
      AccountMailer.delay(:run_at => run_at).welcome(account.users.first)
    end

end
