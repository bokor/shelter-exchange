class CapacitySweeper < ActionController::Caching::Sweeper
  observe Capacity
  
  def after_create(capacity)
    expire_cache_for(capacity)
  end
   
  def after_update(capacity)
    expire_cache_for(capacity)
  end

  def after_destroy(capacity)
    expire_cache_for(capacity)
  end
  
  private
    def expire_cache_for(capacity)
      expire_action(:controller => :capacities, :action => :show, :id => location.id)
      expire_action(:controller => :capacities, :action => :index)
    end
end

#expire fragment after model update
# def after_save
#     expire_fragment('all_available_products')   
#   end