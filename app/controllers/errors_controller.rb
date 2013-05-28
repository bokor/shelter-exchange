class ErrorsController < ApplicationController
  def routing
    if status.present? && status == 410
      render :file => "public/410", :format => :html, :layout => false, :status => 410
    else
      render :file => "public/404", :format => :html, :layout => false, :status => :not_found
    end
  end
end
