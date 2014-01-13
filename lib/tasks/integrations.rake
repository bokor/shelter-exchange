namespace :integrations do

  desc "Generate Background Jobs for all integrations if necessary"
  task :start => :environment do
    Integration.all.each do |integration|
      shelter = integration.shelter

      case integration.to_sym
      when :petfinder
        Delayed::Job.enqueue(PetfinderJob.new(shelter.id))
      when :adopt_a_pet
        Delayed::Job.enqueue(AdoptAPetJob.new(shelter.id))
      end
    end
  end

end

