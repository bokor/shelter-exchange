class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy  
  
  def new
    @user_session = current_account.user_sessions.new
  end
  
  def create
    @user_session = current_account.user_sessions.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_back_or_default root_url
    else
      render :action => :new
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default new_user_session_url
  end
  
  # def new
  #   @user_session = UserSession.new
  # end
  # 
  # def create
  #   @user_session = @current_account.user_session.new(params[:user_session])
  #   if @user_session.save
  #     flash[:notice] = "Successfully logged in."
  #     redirect_to root_url
  #     # redirect_back_or_default users_url
  #   else
  #     render :action => 'new'
  #   end
  # end
  # 
  # def destroy
  #   @user_session = @current_account.user_session.find
  #   @user_session.destroy
  #   flash[:notice] = "Successfully logged out."
  #   #redirect_to root_url
  #   # redirect_back_or_default login_url
  #   redirect_to login_url
  # end
  
end
