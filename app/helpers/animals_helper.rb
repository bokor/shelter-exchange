module AnimalsHelper
  
  def full_breed(animal)
    if animal.is_mix_breed
      animal.secondary_breed.blank? ? animal.primary_breed << " Mix" : animal.primary_breed << " & " << animal.secondary_breed << " Mix"
    else
      animal.primary_breed
    end
  end
  
  def humanize_dob(dob)
    unless dob.blank?
      return time_diff_in_natural_language(dob, current_time)
    end
    ""
  end

end
