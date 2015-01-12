namespace :shelter_exchange do

  desc 'Migrate data in shelter exchange'
  task :migrate => :environment do
    Alert.active.each do |alert|
      Task.create({
        :details => alert.title,
        :due_category => "later",
        :category => "alert",
        :shelter_id => alert.shelter_id,
        :taskable_id => alert.alertable_id,
        :taskable_type => alert.alertable_type,
        :additional_info => alert.description,
      })
    end
  end
end
