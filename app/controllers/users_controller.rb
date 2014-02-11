class UsersController < ApplicationController
  respond_to :html, :js

  skip_before_filter :authenticate_user!, :only => :valid_token

  def index
    @users = @current_account.users.all
    respond_with(@users)
  end

  def edit
    @user = @current_account.users.find(params[:id])
    respond_with(@user)
  end

  def update
    @user = @current_account.users.find(params[:id])
    respond_with(@user) do |format|
      if @user.update_attributes(params[:user])
        @current_ability = nil
        flash[:notice] = "#{@user.name} has been updated."
        format.html { redirect_to users_path }
      else
        flash[:error] = "Error in updating #{@user.name}.  Please try again!"
        format.html { render :action => :index }
      end
    end
  end

  def destroy
    @user = @current_account.users.find(params[:id])
    flash[:notice] = "#{@user.name} has been deleted." if @user.destroy
  end

  def change_password
    @user = @current_account.users.find(params[:id])
    respond_with(@user) do |format|
      if @user.update_with_password(params[:user])
        @current_ability = nil
        sign_in(:user, @user, :bypass => true)
        flash[:notice] = "Your password has been changed."
        format.html { redirect_to users_path }
      else
        flash[:error] = "Error in updating password.  Please try again!"
        format.html { render :action => :index }
      end
    end
  end

  def change_owner
    @current_owner = @current_account.users.find(params[:id])
    @new_owner = @current_account.users.find(params[:new_owner_id])

    if params[:id] != params[:new_owner_id]
      @new_owner.update_attributes({ :role => :owner })
      @current_owner.update_attributes({ :role => :admin })
      @current_ability = nil
      flash[:notice] = "Owner has been changed to #{@new_owner.name}."
    else
      flash[:warning] = "Owner did not change because the same user was selected"
    end
    redirect_to settings_path
  end

  def invite
    @user = User.invite!(params[:user])
  end

  def valid_token
    token_user = User.valid_token?(params[:id])
    if token_user
      sign_in(:user, token_user)
      flash[:notice] = "You have been logged in"
    else
      flash[:alert] = "Login could not be validated"
    end
    redirect_to :root
  end
end

