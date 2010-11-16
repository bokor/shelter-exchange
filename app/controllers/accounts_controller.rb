class AccountsController < ApplicationController
  respond_to :html
  
  def new
    @account = Account.new
    @shelter = @account.shelters.build
    @user = @account.users.build
    respond_with(@account)
  end
  
  def create
    @account = Account.new(params[:account])
      
    respond_with(@account) do |format|
      if @account.save
        flash[:notice] = "WOOF WOOF - Account registered!" #Go to <a href='http://#{@account.subdomain}.#{account_domain}'>http://#{@account.subdomain}.#{account_domain}</a> to log in."
        format.html { render :action => :registered }
      else
        format.html { render :action => :new }
      end
    end
  end
end
