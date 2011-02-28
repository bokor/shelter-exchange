class AlertSweeper < ActionController::Caching::Sweeper
  observe Alert
  
  def after_create(alert)
    expire_cache_for(alert)
  end
   
  def after_update(alert)
    expire_cache_for(alert)
  end

  def after_destroy(alert)
    expire_cache_for(alert)
  end
  
  private
    def expire_cache_for(alert)
      expire_action(:controller => :alerts, :action => :show, :id => location.id)
      expire_action(:controller => :alerts, :action => :index)
    end
end

#expire fragment after model update
# def after_save
#     expire_fragment('all_available_products')   
#   end