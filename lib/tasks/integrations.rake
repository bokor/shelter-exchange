namespace :integrations do

  desc "Generate Background Jobs for all integrations when necessary"
  task :all => :environment do
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

  desc "Generate Background Jobs for all petfinder integrations when necessary"
  task :petfinder => :environment do
    Integration::Petfinder.all.each do |integration|
      Delayed::Job.enqueue(PetfinderJob.new(integration.shelter.id))
    end
  end

  desc "Generate Background Jobs for all adopt a pet integrations when necessary"
  task :adopt_a_pet => :environment do
    Integration::AdoptAPet.all.each do |integration|
      Delayed::Job.enqueue(AdoptAPetJob.new(integration.shelter.id))
    end
  end
end

