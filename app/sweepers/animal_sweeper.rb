# class AnimalSweeper < ActionController::Caching::Sweeper
#   observe Animal
#  
#   def after_save(animal)
#     expire_cache_for(animal)
#   end
#  
#   private
#     def expire_cache_for(animal)
#       expire_fragment("save_a_life/#{animal.id}")
#     end
# end