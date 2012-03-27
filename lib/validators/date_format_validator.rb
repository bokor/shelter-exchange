# class DateFormatValidator < ActiveModel::EachValidator
#   def validate_each(record, attribute, value)
#     day = record.send("#{attribute.to_s}_day")
#     month = record.send("#{attribute.to_s}_month")
#     year = record.send("#{attribute.to_s}_year")
#     value = nil
#     
#     unless year.blank? and month.blank? and day.blank?
#       begin
#         value = Date.civil(year.to_i, month.to_i, day.to_i) #Date.parse("#{year}/#{month}/#{day}")
#       rescue ArgumentError
#         record.send("#{attribute}_day=", day)
#         record.send("#{attribute}_month=", month)
#         record.send("#{attribute}_year=", year) 
#         record.errors.add(attribute, options[:message] || "is an invalid date format")
#       end
#     end
#     
#   end
# end


        # begin
        #   raise ArgumentError if self.date_of_birth_year.length < 4
        #   self.date_of_birth = Date.civil(self.date_of_birth_year.to_i, self.date_of_birth_month.to_i, self.date_of_birth_day.to_i)
        #   self.date_of_birth = Date.parse("#{self.date_of_birth_year}/#{self.date_of_birth_month}/#{self.date_of_birth_day}")
        # rescue ArgumentError
        #   errors.add(:date_of_birth, "is an invalid date format")
        # end
