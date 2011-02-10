class PublicController < ApplicationController
  skip_before_filter :authenticate_user!
  # 
  # def index
  # end
  # 
  # def videos
  # end
  
end
