class LocationSweeper < ActionController::Caching::Sweeper
  observe Location
  
  def after_create(location)
    expire_cache_for(location)
  end
   
  def after_update(location)
    expire_cache_for(location)
  end

  def after_destroy(location)
    expire_cache_for(location)
  end
  
  private
    def expire_cache_for(location)
      expire_action(:controller => :locations, :action => :show, :id => location.id)
      expire_action(:controller => :locations, :action => :index)
    end
end

#expire fragment after model update
# def after_save
#     expire_fragment('all_available_products')   
#   end