class BreedFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    self.send("validate_#{attribute}", record, attribute, value)
  end

  def validate_primary_breed(record, attribute, value)
    unless record.animal_type_id.blank?
      if value.blank?
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
    unless value.blank? || record.other? # Bypass Type = Other
      if record.mix_breed? && find_breed(value, record.animal_type_id).blank?
        record.errors.add(attribute, options[:message] || "must contain a valid breed name")
      end
    end
  end


  #-----------------------------------------------------------------------------
  private

  def find_breed(breed, animal_type_id)
    Breed.valid_for_animal(breed, animal_type_id)
  end

end

