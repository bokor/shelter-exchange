namespace :shelter_exchange do
  desc 'Migrate data in shelter exchange'
  task :migrate => :environment do
    Animal.where('date_of_birth is not null').where('animal_type_id in (1,2,3,4)').reorder(:id).each do |animal|
      from_time = Date.today
      to_time   = animal.date_of_birth
      from_time = from_time.to_time if from_time.respond_to?(:to_time)
      to_time   = to_time.to_time if to_time.respond_to?(:to_time)
      distance_in_seconds = ((to_time - from_time).abs).round

      if distance_in_seconds >= 1.month
        delta = (distance_in_seconds / 1.month).floor
        distance_in_seconds -= delta.month
        delta
      end
      months     = delta.blank? ? 0 : delta.to_i
      animal.age = age(animal, months)
      animal.save!(:validate => false)
    end
  end
end


# Methods
def age(animal, months)
  case animal.animal_type.name
    when "Dog"
      if months <= 12
        "baby"
      elsif months > 12 and months <= 36
        "young"
      elsif months > 36 and months <= 96
        "adult"
      elsif months > 96 
        "senior"
      end
    when "Cat"
      if months <= 12
        "baby"
      elsif months > 12 and months <= 36
        "young"
      elsif months > 36 and months <= 84
        "adult"
      elsif months > 84
        "senior"
      end
    when "Horse"
      if months <= 12
        "baby"
      elsif months > 12 and months <= 36
        "young"
      elsif months > 36 and months <= 168
        "adult"
      elsif months > 168
        "senior"
      end
    when "Rabbit"
      if months <= 1
        "baby"
      elsif months > 1 and months <= 7
        "young"
      elsif months > 7 and months <= 60
        "adult"
      elsif months > 60
        "senior"
      end
  end
end



    