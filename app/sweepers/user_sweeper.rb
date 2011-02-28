class UserSweeper < ActionController::Caching::Sweeper
  observe User
  
  def after_create(user)
    expire_cache_for(user)
  end
   
  def after_update(user)
    expire_cache_for(user)
  end

  def after_destroy(user)
    expire_cache_for(user)
  end
  
  private
    def expire_cache_for(user)
      expire_action(:controller => :users, :action => :show, :id => location.id)
      expire_action(:controller => :users, :action => :index)
    end
end

#expire fragment after model update
# def after_save
#     expire_fragment('all_available_products')   
#   end