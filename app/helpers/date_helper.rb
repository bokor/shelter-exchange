module DateHelper

  def date_attribute_for(record, attribute, value)
    return nil if value.blank?

    unless date_value = record.send("#{attribute}_#{value}")
      date_value = format_date_for(record.send(attribute), value)
    end

    date_value
  end

  def format_date_for(date, type=:default)
    return nil if date.blank?
    case type
      when :short_no_year
        date.strftime("%b %d") #Feb 06
      when :short
        date.strftime("%b %d, %y") #Feb 06, 11
      when :short_full_year
        date.strftime("%b %d, %Y") #Feb 06, 2011
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
end
