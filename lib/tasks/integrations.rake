namespace :integrations do

  desc "Generate Background Jobs for all integrations"
  task :start => :environment do
    Integration.all.each do |integration|
      shelter = integration.shelter

      case integration.class.to_sym
      when :petfinder
        Delayed::Job.enqueue(ShelterExchange::Jobs::PetfinderJob.new(shelter.id))
      when :adopt_a_pet
        Delayed::Job.enqueue(ShelterExchange::Jobs::AdoptAPetJob.new(shelter.id))
      end
    end
  end

end
