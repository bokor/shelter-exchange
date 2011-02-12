class UsersController < ApplicationController
  # load_and_authorize_resource
  respond_to :html, :js
  
  def index
    respond_with(@user = current_user)
  end
  
  def edit
    respond_with(@user = current_user)
  end
  
  def update
    respond_with(@user = current_user) do |format|
      if @user.update_attributes(params[:user])  
        flash[:notice] = "#{@user.name} has been updated."
        format.html { redirect_to users_path }
      else
        format.html { render :action => :edit }
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
    redirect_to users_path and return
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
