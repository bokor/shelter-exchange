module CapacitiesHelper
  
  def capacity_status(capacity, animal_count)
    if (animal_count >= (capacity.max_capacity * 0.8).round.to_i)
  		return "red"
    elsif (animal_count >= (capacity.max_capacity * 0.6).round.to_i) and (animal_count < (capacity.max_capacity * 0.8).round.to_i)
  		return "yellow"
    elsif (animal_count < (capacity.max_capacity * 0.6).round.to_i)
      return "green"
  	end
  end
end