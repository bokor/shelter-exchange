class TaskSweeper < ActionController::Caching::Sweeper
  observe Task
  
  def after_create(task)
    expire_cache_for(task)
  end
   
  def after_update(task)
    expire_cache_for(task)
  end

  def after_destroy(task)
    expire_cache_for(task)
  end
  
  private
    def expire_cache_for(task)
      expire_action(:controller => :tasks, :action => :show, :id => location.id)
      expire_action(:controller => :tasks, :action => :index)
    end
end

#expire fragment after model update
# def after_save
#     expire_fragment('all_available_products')   
#   end