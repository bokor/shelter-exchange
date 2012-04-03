# class ShelterSweeper < ActionController::Caching::Sweeper
#   observe Shelter
#  
#   def after_save(shelter)
#     expire_cache_for(shelter)
#   end
#  
#   private
#     def expire_cache_for(shelter)
#       expire_fragment("help_a_shelter/#{shelter.id}")
#     end
# end