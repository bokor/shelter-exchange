class Admin::UsersController < Admin::ApplicationController
  respond_to :html, :js
  
  def index
    @users = User.admin_list.paginate(:page => params[:page], :per_page => 50).all
  end
  
  def live_search
    @users = User.admin_live_search(params[:q].strip).paginate(:page => params[:page], :per_page => 50).all
  end
  
end
