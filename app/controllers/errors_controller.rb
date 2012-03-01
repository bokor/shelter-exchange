class ErrorsController < ApplicationController
  def routing
    if status_code == 410
      render :file => "#{Rails.root}/public/410.html", :layout => false, :status => 410
    else
      render :file => "#{Rails.root}/public/404.html", :layout => false, :status => 404
    end
  end
end