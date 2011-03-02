class PublicController < ApplicationController
  skip_before_filter :authenticate_user!, :current_account, :current_shelter, :set_shelter_timezone
  
  # def index
  # end
  # 
  # def videos
  # end
  
end
