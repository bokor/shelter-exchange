module AnimalsHelper
  
  def full_breed(animal)
    if animal.is_mix_breed
      animal.secondary_breed.blank? ? animal.primary_breed + " Mix" : animal.primary_breed + " & " + animal.secondary_breed + " Mix"
    else
      animal.primary_breed
    end
  end
  
  def filter_by_animal_statuses
    AnimalStatus::EXTRA_STATUS_FILTERS + AnimalStatus.all.map {|s| [s.name,s.id]}
  end
  
  def humanize_dob(dob)
    time_diff_in_natural_language(dob, current_time) unless dob.blank?
  end
  
  def date_of_birth_value(type, animal)
    return nil if type.blank?
    case type
      when :month
        return animal.date_of_birth_month unless animal.date_of_birth_month.blank?
      when :day
        return animal.date_of_birth_day unless animal.date_of_birth_day.blank?
      when :year
        return animal.date_of_birth_year unless animal.date_of_birth_year.blank?
    end
    format_date(type, animal.date_of_birth)
  end
  
  def arrival_date_value(type, animal)
    return nil if type.blank?
    case type
      when :month
        return animal.arrival_date_month unless animal.arrival_date_month.blank?
      when :day
        return animal.arrival_date_day unless animal.arrival_date_day.blank?
      when :year
        return animal.arrival_date_year unless animal.arrival_date_year.blank?
    end
    format_date(type, animal.arrival_date)
  end
  
  def euthanasia_date_value(type, animal)
    return nil if type.blank?
    case type
      when :month
        return animal.euthanasia_date_month unless animal.euthanasia_date_month.blank?
      when :day
        return animal.euthanasia_date_day unless animal.euthanasia_date_day.blank?
      when :year
        return animal.euthanasia_date_year unless animal.euthanasia_date_year.blank?
    end
    format_date(type, animal.euthanasia_date)
  end
  
  def community_animal_status(animal)
    if [:adopted, :reclaim, :deceased, :euthanized].any?{ |key| AnimalStatus::STATUSES[key] == animal.animal_status_id }
      animal.animal_status.name + humanize_status_change_date(animal)
    else 
      animal.animal_status.name
    end
  end
  
  def public_animal_status(animal)
    case animal.animal_status_id
      when AnimalStatus::STATUSES[:adopted]
        animal.animal_status.name + humanize_status_change_date(animal)
      when AnimalStatus::STATUSES[:available_for_adoption]
        animal.animal_status.name
      when AnimalStatus::STATUSES[:foster_care]
        animal.animal_status.name
      else 
        "No longer available for adoption"
    end
  end
  
  def adoption_date(animal)
    AnimalStatus::STATUSES[:adopted] == animal.animal_status_id ? humanize_status_change_date(animal) : nil
  end
  
  def humanize_status_change_date(animal)
    " on #{format_date(:short_full_year, animal.status_change_date)}" 
  end

end
