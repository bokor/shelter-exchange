module CapacitiesHelper

  def capacity_status(capacity, animal_count)
    if (animal_count >= (capacity.max_capacity * 0.8).round.to_i)
      "red"
    elsif (animal_count >= (capacity.max_capacity * 0.6).round.to_i) &&
          (animal_count < (capacity.max_capacity * 0.8).round.to_i)
      "yellow"
    elsif (animal_count < (capacity.max_capacity * 0.6).round.to_i)
      "green"
    end
  end
end

