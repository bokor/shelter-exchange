class Public::AccountsController < Public::ApplicationController
  respond_to :html
  
  # caches_action :new, :expires_in => 1.hour
  
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
        format.html { redirect_to registered_public_account_path(@account) }
      else
        format.html { render :action => :new }
      end
    end
  end
  
  def registered
    @account = Account.find(params[:id])
    @shelter = @account.shelters.first
  end
  
end

  
  # Add if the error has been fixed so that every one would get redirected to the signup page
  # def index
  #   redirect_to public_signup_path
  # end
