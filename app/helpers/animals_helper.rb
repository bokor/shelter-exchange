module AnimalsHelper
  
  def full_breed(animal)
    if animal.is_mix_breed
      animal.secondary_breed.blank? ? animal.primary_breed << " Mix" : animal.primary_breed << " & " << animal.secondary_breed << " Mix"
    else
      animal.primary_breed
    end
  end
  
  def humanize_dob(dob)
    age = ""
    unless dob.blank?
      days_old = Date.today.day - dob.day
      months_old = Date.today.month - dob.month - (days_old < 0 ? 1 : 0)
      years_old = Date.today.year - dob.year - (months_old < 0 ? 1 : 0)
      age << "#{years_old.to_s}" << (years_old == 1 ? " year" : " years") if years_old > 0
      age << " and " if years_old > 0 and months_old > 0
      age << "#{months_old.to_s}" << (months_old == 1 ? " month" : " months") if months_old > 0
      age << "Less than a month" if years_old <= 0 and months_old <= 0
    end
    return age
  end

end
