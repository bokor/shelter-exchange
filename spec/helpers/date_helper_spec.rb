require "spec_helper"

describe DateHelper, "#date_attribute_for" do
  # def date_attribute_for(record, attribute, value)
  #   return nil if value.blank?

  #   if record.send("#{attribute}_#{value}")
  #     record.send("#{attribute}_#{value}")
  #   else
  #     format_date_for(record.send(attribute), value)
  #   end
  # end
  it "" do
    expect(
      helper.date_attribute_for(record, attribute, value)
    ).to eq("")
  end
end

describe DateHelper, "#format_date" do
  # def format_date_for(date, type=:default)
  #   return nil if date.blank?
  #   case type
  #     when :short_no_year
  #       date.strftime("%b %d") #Feb 06
  #     when :short
  #       date.strftime("%b %d, %y") #Feb 06, 11
  #     when :short_full_year
  #       date.strftime("%b %d, %Y") #Feb 06, 2011
  #     when :long
  #       date.strftime("%B %d, %Y") #February 06, 2011
  #     when :long_day_of_week
  #       date.strftime("%a %B %d, %Y") #Sun February 06, 2011
  #     when :month
  #       date.strftime("%m") #02/06/2011
  #     when :day
  #       date.strftime("%d") #02/06/2011
  #     when :year
  #       date.strftime("%Y") #02/06/2011
  #     when :default
  #       date.strftime("%m/%d/%Y") #02/06/2011
  #   end
  # end
  it "" do
    expect(
      helper.format_date(type, date)
    ).to eq("")
  end
end

describe DateHelper, "#time_diff_in_natural_language" do
  # def time_diff_in_natural_language(from_time, to_time)
  #   from_time = from_time.to_time if from_time.respond_to?(:to_time)
  #   to_time = to_time.to_time if to_time.respond_to?(:to_time)
  #   distance_in_seconds = ((to_time - from_time).abs).round
  #   components = []

  #   %w(year month).each do |interval|
  #     # For each interval type, if the amount of time remaining is greater than
  #     # one unit, calculate how many units fit into the remaining time.
  #     if distance_in_seconds >= 1.send(interval)
  #       delta = (distance_in_seconds / 1.send(interval)).floor
  #       distance_in_seconds -= delta.send(interval)
  #       components << pluralize(delta, interval)
  #     end
  #   end

  #   if components.blank?
  #     %w(week).each do |interval|
  #       # For each interval type, if the amount of time remaining is greater than
  #       # one unit, calculate how many units fit into the remaining time.
  #       if distance_in_seconds >= 1.send(interval)
  #         delta = (distance_in_seconds / 1.send(interval)).floor
  #         distance_in_seconds -= delta.send(interval)
  #         components << pluralize(delta, interval)
  #       end
  #     end
  #   end
  #   components.blank? ? "Less than 1 week" : components.join(" and ")
  # end

  it "" do
    expect(
      helper.time_diff_in_natural_language(from_time, to_time)
    ).to eq("")
  end
end

describe DateHelper, "#months_between" do
  # def months_between(from_time, to_time)
  #   from_time = from_time.to_time if from_time.respond_to?(:to_time)
  #   to_time = to_time.to_time if to_time.respond_to?(:to_time)
  #   distance_in_seconds = ((to_time - from_time).abs).round

  #   if distance_in_seconds >= 1.month
  #     delta = (distance_in_seconds / 1.month).floor
  #     distance_in_seconds -= delta.month
  #     delta
  #   end

  #   delta.blank? ? 0 : delta.to_i
  # end

  it "" do
    expect(
      helper.months_between(from_time, to_time)
    ).to eq("")
  end
end
