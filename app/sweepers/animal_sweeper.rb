class AnimalSweeper < ActionController::Caching::Sweeper
  observe Animal
  
  def after_create(animal)
    expire_cache_for(animal)
  end
   
  def after_update(animal)
    expire_cache_for(animal)
  end

  def after_destroy(animal)
    expire_cache_for(animal)
  end
  
  private
    def expire_cache_for(animal)
      expire_action(:controller => :animals, :action => :show, :id => location.id)
      expire_action(:controller => :animals, :action => :index)
    end
end

#expire fragment after model update
# def after_save
#     expire_fragment('all_available_products')   
#   end