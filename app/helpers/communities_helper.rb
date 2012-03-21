module CommunitiesHelper
  
  def city_zipcode_default
    "#{@current_shelter.city}, #{@current_shelter.state} #{@current_shelter.zip_code}"
  end
  
  def get_directions_address(shelter)
    [shelter.street, shelter.street_2, shelter.city, shelter.state, shelter.zip_code].join('+')
  end
  
  def days_left(from_time, to_time = Date.today)
    from_time = from_time.to_time if from_time.respond_to?(:to_time)
    to_time = to_time.to_time if to_time.respond_to?(:to_time)
    
    if from_time.present? and (from_time <= to_time + 2.weeks)
      distance_in_seconds = ((to_time - from_time).abs).round
      components = []
    
      unless from_time < current_time 
        %w(day).each do |interval|
          if distance_in_seconds >= 1.send(interval)
            delta = (distance_in_seconds / 1.send(interval)).floor
            distance_in_seconds -= delta.send(interval)
            components << pluralize(delta, interval)
          end
        end
      end
      output = image_tag("icon_community_alert.png") + " "
      output += (components.blank? ? "Urgent!" : components.join() << " left").upcase
      output
    else
      "&nbsp;".html_safe
    end
  end

end