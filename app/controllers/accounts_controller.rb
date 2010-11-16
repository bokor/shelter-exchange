class AccountsController < ApplicationController
  respond_to :html #, :js
  
  def new
    @account = Account.new
    @user = @account.users.build
    @shelter = @account.shelters.build
  end
  
  def create
    @account = Account.new(params[:account])
    if @account.save
      flash[:notice] = "Account registered! Go to <a href='http://#{@account.subdomain}.#{account_domain}'>http://#{@account.subdomain}.#{account_domain}</a> to log in." 
    end
  end
end
