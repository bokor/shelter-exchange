class Public::AccountsController < Public::ApplicationController
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
        flash[:notice] = "Account registered!"
        format.html { render :action => :registered }
      else
        format.html { render :action => :new }
      end
    end
  end
end
