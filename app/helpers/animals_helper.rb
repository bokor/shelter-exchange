module AnimalsHelper

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
    if animal.adopted? or animal.reclaimed? or animal.deceased? or animal.euthanized? or animal.transferred?
      animal.animal_status.name + humanize_status_change_date(animal)
    else
      animal.animal_status.name
    end
  end

  def public_animal_status(animal)
    if animal.adopted? or animal.reclaimed? or animal.transferred?
      animal.animal_status.name + humanize_status_change_date(animal)
    elsif animal.deceased? or animal.euthanized?
      "No longer available for adoption"
    else
      animal.animal_status.name
    end
  end

  def adoption_date(animal)
    humanize_status_change_date(animal) if animal.adopted?
  end

  def humanize_status_change_date(animal)
    " on #{format_date(:short_full_year, animal.status_change_date)}"
  end

  def fancybox_video_url(animal)
    you_tube_id = find_you_tube_id(animal.video_url)
    unless you_tube_id.blank?
      "//www.youtube.com/v/#{you_tube_id}" #"?version=3&enablejsapi=1"
    else
      animal.video_url
    end
  end

  def find_you_tube_id(url)
    # url.scan(Regexp.union(ANIMAL_VIDEO_URL_FORMAT)){|m| return m.join.strip unless m.blank?}
    url.match(VIDEO_URL_REGEX)[5]
  end

end

