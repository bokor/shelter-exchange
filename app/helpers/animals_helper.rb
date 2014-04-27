module AnimalsHelper

  def filter_by_animal_statuses
    AnimalStatus::EXTRA_STATUS_FILTERS + AnimalStatus.all.map {|s| [s.name,s.id] }
  end

  def humanize_dob(dob)
    time_diff_in_natural_language(dob, Time.zone.now) unless dob.blank?
  end

  def public_animal_status(animal)
    if animal.deceased? || animal.euthanized?
      "No longer available for adoption"
    else
      animal.animal_status.name
    end
  end

  def fancybox_video_url(animal)
    you_tube_id = find_you_tube_id(animal.video_url)
    unless you_tube_id.blank?
      "//www.youtube.com/v/#{you_tube_id}"
    else
      animal.video_url
    end
  end

  def find_you_tube_id(url)
    url.match(VIDEO_URL_REGEX)[5] rescue nil
  end
end

