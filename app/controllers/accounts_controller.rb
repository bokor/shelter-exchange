class AccountsController < ApplicationController
  # before_filter :require_no_user
  layout "accounts"
  respond_to :html, :js
  
  def new
    @account = Account.new
    @user = @account.users.build
    @shelter = @account.shelters.build
    respond_with(@account)
  end
  
  def create
    @account = Account.new(params[:account])
    flash[:notice] = "#{@account.subdomain} has been created." if @account.save
    respond_with(@account)
  end
end
