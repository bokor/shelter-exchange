class ShelterSweeper < ActionController::Caching::Sweeper
  observe Shelter

  def after_update(shelter)
    expire_cache_for(shelter)
  end
  
  def after_create(shelter)
    expire_cache_for(shelter)
  end
  
  private
    def expire_cache_for(shelter)
      # expire_action(:controller => :shelters, :action => :show, :id => shelter.id)
      # expire_action(:controller => :shelters, :action => :index)
      expire_fragment('shelter_kml_file')   
    end
end

#expire fragment after model update
# def after_save
#     expire_fragment('all_available_products')   
#   end