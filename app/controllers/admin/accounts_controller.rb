class Admin::AccountsController < Admin::ApplicationController
  respond_to :html, :js
  
  def edit
    @account = Account.find(params[:id])
  end
  
  def update
    @account = Account.find(params[:id])
    flash[:notice] = "#{@account.subdomain} has been #{@account.blocked? ? 'blocked' : 'approved'}." if @account.update_attributes(params[:account])
  end
  
end