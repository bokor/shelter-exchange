class DateFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    day = record.send("#{attribute}_day")
    month = record.send("#{attribute}_month")
    year = record.send("#{attribute}_year")
    
    record[attribute] = nil 
    unless year.blank? and month.blank? and day.blank?
      begin
        # raise ArgumentError if year.length < 4 
        record[attribute] = Date.parse("#{year.to_i}/#{month.to_i}/#{day.to_i}") #Date.civil(year.to_i, month.to_i, day.to_i)
      rescue ArgumentError
        record.errors.add(attribute, options[:message] || "is an invalid date format")
      end
    end
  end
end