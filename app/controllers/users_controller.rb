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
        flash[:notice] = "#{@user.name} has been updated."
        format.html { redirect_to users_path }
      else
        flash[:error] = "Error in updating password.  Please try again!"
        format.html { render :action => :index }
      end
    end
  end
  
  def generate_token
    # @user = User.find(params[:id])   
    @user = current_user
    @user.reset_authentication_token!
    redirect_to users_path
  end

  def delete_token
    # @user = User.find(params[:id])   
    @user = current_user
    @user.authentication_token = nil
    @user.save
    redirect_to users_path
  end

end

