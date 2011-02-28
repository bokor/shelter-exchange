class ParentSweeper < ActionController::Caching::Sweeper
  observe Parent
  
  def after_create(parent)
    expire_cache_for(parent)
  end
   
  def after_update(parent)
    expire_cache_for(parent)
  end

  def after_destroy(parent)
    expire_cache_for(parent)
  end
  
  private
    def expire_cache_for(parent)
      expire_action(:controller => :parents, :action => :show, :id => parent.id)
      expire_action(:controller => :parents, :action => :index)
    end
end

#expire fragment after model update
# def after_save
#     expire_fragment('all_available_products')   
#   end