module CommunitiesHelper
  def get_directions_address
    [@shelter.street, @shelter.street_2, @shelter.city, @shelter.state, @shelter.zip_code].join('+')
  end
  
  def days_left(from_time, to_time)
    from_time = from_time.to_time if from_time.respond_to?(:to_time)
    to_time = to_time.to_time if to_time.respond_to?(:to_time)
    distance_in_seconds = ((to_time - from_time).abs).round
    components = []

    %w(day).each do |interval|
      if distance_in_seconds >= 1.send(interval)
        delta = (distance_in_seconds / 1.send(interval)).floor
        distance_in_seconds -= delta.send(interval)
        components << pluralize(delta, interval)
      end
    end
    components.join() << " left"
  end
  

end
