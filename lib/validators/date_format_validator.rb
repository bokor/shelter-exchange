class DateFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    day = record.send("#{attribute}_day")
    month = record.send("#{attribute}_month")
    year = record.send("#{attribute}_year")

    unless year.blank? && month.blank? && day.blank?

      begin
        raise ArgumentError if year.blank? || year.size < 4 # Raise if year is blank or less than 4 to keep with format
        date = Date.parse("#{year.to_i}/#{month.to_i}/#{day.to_i}")
        raise ArgumentError, "date_of_birth" if attribute == :date_of_birth && date > Date.today
      rescue ArgumentError => e
        if e.message == "date_of_birth"
          record.errors.add(attribute, options[:message] || "has to be before today's date")
        else
          record.errors.add(attribute, options[:message] || "is an invalid date format")
        end
      end

    end
  end
end
