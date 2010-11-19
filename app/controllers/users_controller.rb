class UsersController < ApplicationController
  
  def valid
    token_user = User.valid?(params)
    if token_user
      sign_in(:user, token_user)
      flash[:notice] = "You have been logged in"
    else
      flash[:alert] = "Login could not be validated"
    end
    redirect_to :root
  end
  
  
end
