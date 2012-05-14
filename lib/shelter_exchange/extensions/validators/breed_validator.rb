class BreedValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    self.send("validate_#{attribute}", record, attribute, value)
  end
  
  def validate_primary_breed(record, attribute, value)
    unless record.animal_type_id.blank?
      if record.primary_breed.blank?
        record.errors.add_on_blank(attribute)
      else
        unless record.other?  # Bypass Type = Other
          if find_breed(value, record.animal_type_id).blank?
            record.errors.add(attribute, options[:message] || "must contain a valid breed name")
          end
        end
      end
    end
  end
  
  def validate_secondary_breed(record, attribute, value)
    unless record.other? # Bypass Type = Other
      if record.mix_breed? and find_breed(value, record.animal_type_id).blank?
        record.errors.add(attribute, options[:message] || "must contain a valid breed name")
      end
    end
  end
  
  private 
  
    def find_breed(breed, animal_type_id)
      Breed.valid_for_animal(breed, animal_type_id)
    end
  
end



# def primary_breed_valid?
#   unless self.animal_type_id.blank?
#     if self.primary_breed.blank?
#       errors.add_on_blank(:primary_breed)
#     else
#       unless self.other?  # Bypass Type = Other
#         if Breed.valid_for_animal(self.primary_breed, self.animal_type_id).blank?
#           errors.add(:primary_breed, "must contain a valid breed from the list")
#         end
#       end
#     end
#   end
# end
# 
# def secondary_breed_valid?
#   unless self.other? # Bypass Type = Other
#     if self.is_mix_breed and self.secondary_breed.present?
#       if Breed.valid_for_animal(self.secondary_breed, self.animal_type_id).blank?
#         errors.add(:secondary_breed, "must contain a valid breed from the list")
#       end
#     end
#   end
# end