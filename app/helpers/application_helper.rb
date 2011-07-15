module ApplicationHelper
  
  def title(title)
    content_for(:title) { title.to_s }
  end
  
  def javascripts(*files)
    content_for(:javascripts) { javascript_include_tag(*files) }
  end
  
  def stylesheets(*files)
    content_for(:stylesheets) { stylesheet_link_tag(*files) }
  end
  
  def selected_navigation(element)
    request.fullpath =~ /\/#{element.to_s}/ ? "current" : ""
  end
  
  def format_date(type, date)
    return nil if date.blank?
    case type
      when :full_month_only
        date.strftime("%B") #February
      when :short_no_year 
        date.strftime("%b %d") #Feb 06
      when :short
        date.strftime("%b %d, %y") #Feb 06, 11
      when :short_full_year
        date.strftime("%b %d, %Y") #Feb 06, 11
      when :long 
        date.strftime("%B %d, %Y") #February 06, 2011
      when :long_day_of_week
        date.strftime("%a %B %d, %Y") #Sun February 06, 2011
      when :month
        date.strftime("%m") #02/06/2011
      when :day
        date.strftime("%d") #02/06/2011
      when :year
        date.strftime("%Y") #02/06/2011
      when :default
        date.strftime("%m/%d/%Y") #02/06/2011
    end
  end
  
  def current_month
    Time.zone.now.month
  end
  
  def current_year
    Time.zone.now.year
  end
  
  def current_time
    Time.zone.now
  end
  
  def time_diff_in_natural_language(from_time, to_time)
    from_time = from_time.to_time if from_time.respond_to?(:to_time)
    to_time = to_time.to_time if to_time.respond_to?(:to_time)
    distance_in_seconds = ((to_time - from_time).abs).round
    components = []

    %w(year month).each do |interval|
      # For each interval type, if the amount of time remaining is greater than
      # one unit, calculate how many units fit into the remaining time.
      if distance_in_seconds >= 1.send(interval)
        delta = (distance_in_seconds / 1.send(interval)).floor
        distance_in_seconds -= delta.send(interval)
        components << pluralize(delta, interval)
      end
    end
    
    if components.blank?
      %w(week).each do |interval|
        # For each interval type, if the amount of time remaining is greater than
        # one unit, calculate how many units fit into the remaining time.
        if distance_in_seconds >= 1.send(interval)
          delta = (distance_in_seconds / 1.send(interval)).floor
          distance_in_seconds -= delta.send(interval)
          components << pluralize(delta, interval)
        end
      end
    end
    components.blank? ? "Less than 1 week" : components.join(" and ")
    
  end
  
  def has_error_message?(object, field)
    create_error_message(object.errors[field].to_sentence) unless object.errors[field].blank?
  end
  
  def create_error_message(msg)
    ['<p class="error">', msg.capitalize, '</p>'].join.html_safe
  end
  
  def possessive(str)
    (str[-1,1] == "s") ? str + "'" : str + "'s"
  end
  
  def s3_expiring_url(file_name, authenticated = false, use_ssl = false, time = 3600)
    # Get Object
    s3_object = AWS::S3::S3Object.find(file_name, S3_BUCKET)
    # Get Last Modified Time
    last_modified = s3_object.about["last-modified"].to_time.to_i unless s3_object.blank?
    # Get URL with Options
    logger.debug(s3_object.url(:expires_in => time, :use_ssl => use_ssl, :authenticated => authenticated))
    AWS::S3::S3Object.url_for(file_name, S3_BUCKET, :expires_in => time, :use_ssl => use_ssl, :authenticated => authenticated)
  end
  
end


#   %a - The abbreviated weekday name (``Sun'')
#   %A - The  full  weekday  name (``Sunday'')
#   %b - The abbreviated month name (``Jan'')
#   %B - The  full  month  name (``January'')
#   %c - The preferred local date and time representation
#   %d - Day of the month (01..31)
#   %e - Day of the month without leading zeroes (1..31)
#   %H - Hour of the day, 24-hour clock (00..23)
#   %I - Hour of the day, 12-hour clock (01..12)
#   %j - Day of the year (001..366)
#   %k - Hour of the day, 24-hour clock w/o leading zeroes ( 0..23)
#   %l - Hour of the day, 12-hour clock w/o leading zeroes ( 1..12)
#   %m - Month of the year (01..12)
#   %M - Minute of the hour (00..59)
#   %p - Meridian indicator (``AM''  or  ``PM'')
#   %P - Meridian indicator (``am''  or  ``pm'')
#   %S - Second of the minute (00..60)
#   %U - Week  number  of the current year,
#           starting with the first Sunday as the first
#           day of the first week (00..53)
#   %W - Week  number  of the current year,
#           starting with the first Monday as the first
#           day of the first week (00..53)
#   %w - Day of the week (Sunday is 0, 0..6)
#   %x - Preferred representation for the date alone, no time
#   %X - Preferred representation for the time alone, no date
#   %y - Year without a century (00..99)
#   %Y - Year with century
#   %Z - Time zone name
#   %z - Time zone expressed as a UTC offset (``-04:00'')
#   %% - Literal ``%'' character