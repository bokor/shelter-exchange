class Admin::UsersController < Admin::ApplicationController
  respond_to :html, :js
  
  def index
    @users = User.admin_list.all.paginate(:per_page => 50, :page => params[:page])
  end
  
  def live_search
    @users = User.admin_live_search(params[:q].strip).paginate(:per_page => 25, :page => params[:page])
  end
  
end