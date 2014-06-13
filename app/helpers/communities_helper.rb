module CommunitiesHelper

  def get_directions_address(shelter)
    address = [shelter.street, shelter.street_2, shelter.city, shelter.state, shelter.zip_code].join('+')
    URI::encode(address)
  end

  def days_left(from_date)
    days_left = from_date.mjd - Time.zone.today.mjd rescue nil

    if days_left.blank? || days_left > 14
      alert_text = "&nbsp;"
    elsif days_left >= 1 && days_left <= 14
      alert_text = image_tag('icon_community_alert.png') + " #{pluralize(days_left, 'day')} left".upcase
    elsif days_left <= 0
      alert_text = image_tag("icon_community_alert.png") + " urgent!".upcase
    end

    alert_text.html_safe
  end
end

