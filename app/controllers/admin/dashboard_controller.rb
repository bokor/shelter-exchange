class Admin::DashboardController < Admin::ApplicationController
  respond_to :html, :js
  
  def index
    @transfers = Transfer.all
  end
  
end
