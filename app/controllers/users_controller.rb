class UsersController < ApplicationController
  # before_filter :authenticate_user!
  respond_to :html, :js
  
  def index
    @user = current_user
    respond_with(@user)
  end
  
  def show
    redirect_to users_path and return
  end
  
  def edit
    @user = current_user
    respond_with(@user)
  end
  
  def new
    redirect_to users_path and return
  end
  
  def create
    redirect_to users_path and return
  end
  
  def update
    @user = current_user
    respond_with(@user) do |format|
      if @user.update_attributes(params[:user])  
        flash[:notice] = "#{@user.name} has been updated."
        format.html { redirect_to users_path }
      else
        format.html { render :action => :edit }
      end
    end
  end
  
  def destroy
    redirect_to users_path and return
  end
  
  # def valid
  #   token_user = User.valid?(params)
  #   if token_user
  #     sign_in(:user, token_user)
  #     flash[:notice] = "You have been logged in"
  #   else
  #     flash[:alert] = "Login could not be validated"
  #   end
  #   redirect_to :root
  # end
  # 
  
end
