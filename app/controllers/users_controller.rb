class UsersController < ApplicationController
  # load_and_authorize_resource
  respond_to :html, :js
  
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
        flash[:notice] = "#{@user.name} has been updated."
        format.html { redirect_to users_path }
      else
        flash[:error] = "Error in updating #{@user.name}.  Please try again!"
        format.html { render :action => :index }
      end
    end
  end
  
  def show
    redirect_to users_path and return
  end
  
  def new
    redirect_to users_path and return
  end
  
  def create
    redirect_to users_path and return
  end
  
  def destroy
    @user = @current_account.users.find(params[:id])
    @user.destroy
    flash[:notice] = "#{@user.name} has been deleted."
  end
    
  def change_password
    @user = @current_account.users.find(params[:id])
    respond_with(@user) do |format|
      if @user.update_attributes(params[:user])  
        flash[:notice] = "Your password has been changed.  Please login with your new password."
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
      flash[:notice] = "Owner has been changed to #{@new_owner.name}."
    else 
      flash[:warning] = "Owner did not change because the same user was selected"
    end
    redirect_to settings_path
  end

end

