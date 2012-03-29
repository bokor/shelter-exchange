class DateFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    day = record.send("#{attribute}_day")
    month = record.send("#{attribute}_month")
    year = record.send("#{attribute}_year")
    
    record[attribute] = nil 
    # if options[:allow_blank] or options[:allow_nil]
      unless year.blank? and month.blank? and day.blank?
        begin
          # raise ArgumentError if year.length < 4 
          record[attribute] = Date.parse("#{year.to_i}/#{month.to_i}/#{day.to_i}") #Date.civil(year.to_i, month.to_i, day.to_i)
        rescue ArgumentError
          record.errors.add(attribute, options[:message] || "is an invalid date format")
        end
      end
    # else
      # record.errors[attribute] << (options[:message] || "is a required date")
    # end
  end
end

# record.errors.add(attribute, options[:message] || "is an invalid date format")

# def date_of_birth_valid?
#   self.date_of_birth = nil
#   unless self.date_of_birth_year.blank? and self.date_of_birth_month.blank? and self.date_of_birth_day.blank?
#     begin
#       self.date_of_birth = Date.parse("#{self.date_of_birth_year}/#{self.date_of_birth_month}/#{self.date_of_birth_day}")
#     rescue ArgumentError
#       errors.add(:date_of_birth, "is an invalid date format")
#     end
#   end
# end
# 
# def arrival_date_valid?
#   self.arrival_date = nil
#   unless self.arrival_date_year.blank? and self.arrival_date_month.blank? and self.arrival_date_day.blank?
#     begin
#       self.arrival_date = Date.parse("#{self.arrival_date_year}/#{self.arrival_date_month}/#{self.arrival_date_day}")
#     rescue ArgumentError
#       errors.add(:arrival_date, "is an invalid date format")
#     end
#   end
# end
# 
# def euthanasia_date_valid?
#   if is_kill_shelter?
#     self.euthanasia_date = nil
#     unless self.euthanasia_date_year.blank? and self.euthanasia_date_month.blank? and self.euthanasia_date_day.blank?
#       begin
#         self.euthanasia_date = Date.parse("#{self.euthanasia_date_year}/#{self.euthanasia_date_month}/#{self.euthanasia_date_day}")
#       rescue ArgumentError
#         errors.add(:euthanasia_date, "is an invalid date format")
#       end
#     # else
#       # errors.add_on_blank(:euthanasia_date)
#     end
#   end
# end
