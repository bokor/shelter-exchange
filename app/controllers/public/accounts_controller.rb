class Public::AccountsController < Public::ApplicationController
  before_filter :disable_account_creation

  respond_to :html

  def new
    @account = Account.new
    @shelter = @account.shelters.build
    @user = @account.users.build
    respond_with(@account)
  end

  def create
    @account = Account.new(params[:account])
    @account.users.first.role = User::OWNER

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

  private

  def disable_account_creation
    if ShelterExchange.settings.app_disabled?
      render 'errors/app_disabled', :format => :html
    end
  end
end

