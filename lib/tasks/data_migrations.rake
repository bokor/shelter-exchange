namespace :shelter_exchange do

  desc 'Migrate data in shelter exchange'
  task :migrate => :environment do
    ActiveRecord::Base.logger = Logger.new(STDOUT)

    # Get all Parents
    Parent.includes(:placements, :notes => :documents).each do |parent|

      # Only Migrate if there are placements else they will need to migrate from the app
      unless parent.placements.empty?
        shelter = parent.placements.first.shelter

        # Create contact from parent
        contact = shelter.contacts.new \
          :first_name => parent.first_name,
          :last_name => parent.last_name,
          :street => parent.street,
          :city => parent.city,
          :state => parent.state,
          :zip_code => parent.zip_code,
          :phone => parent.phone,
          :mobile => parent.mobile,
          :email => parent.email

        if contact.save

          # Move the parent notes to the new contact
          parent.notes.each do |note|
            note.notable = contact
            note.shelter = shelter
            note.save!
          end

          # Get all the Parent's Placements
          parent.placements.includes(:comments, :animal => [:status_histories]).each do |placement|

            # Update contact roles based on parent placements
            case placement.status
            when "adopted"
              contact.update_column(:adopter, true)
            when "foster_care"
              contact.update_column(:foster, true)
            end

            # Get the Status History
            status_history = placement.animal.
              status_histories.where(:animal_status_id => AnimalStatus::STATUSES[placement.status.to_sym]).first rescue nil

            if status_history.blank?
              # Create a status history if one doesn't exist with the current status type (adopted, foster_care)
              status_history = StatusHistory.create \
                :animal => placement.animal,
                :shelter => placement.shelter,
                :contact => contact,
                :animal_status_id => AnimalStatus::STATUSES[placement.status.to_sym],
                :status_date => placement.created_at.to_date
            else
              # Update Status History to add the new contact
              status_history.contact = contact
              status_history.save
            end

            placement.comments.each do |comment|
              comment.commentable = status_history
              comment.save
            end
          end
        end

        # Destroy Parent
        parent.reload.destroy
      end
    end
  end
end
