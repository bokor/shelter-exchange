class AccommodationSweeper < ActionController::Caching::Sweeper
  observe Accommodation
  
  def after_create(accommodation)
    expire_cache_for(accommodation)
  end
   
  def after_update(accommodation)
    expire_cache_for(accommodation)
  end

  def after_destroy(accommodation)
    expire_cache_for(accommodation)
  end
  
  private
    def expire_cache_for(accommodation)
      expire_action(:controller => :accommodations, :action => :show, :id => location.id)
      expire_action(:controller => :accommodations, :action => :index)
    end
end

#expire fragment after model update
# def after_save
#     expire_fragment('all_available_products')   
#   end