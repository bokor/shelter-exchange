require "csv"

class DataExportJob

  def initialize(shelter_id)
    @start_time = Time.now
    @shelter = Shelter.find(shelter_id)
    @base_dir = File.join(Rails.root, "tmp", "data_export")
    @write_dir = File.join(@base_dir, "#{@shelter.id}")
    @zip_filename = "#{@shelter.id}.zip"
    @uploaded_file = File.join(@base_dir, @zip_filename)
  end

  def perform
    # 1. Setup and create directories.
    photos_dir = File.join(@write_dir, "photos")
    documents_dir = File.join(@write_dir, "documents")
    FileUtils.mkdir_p(photos_dir)
    FileUtils.mkdir_p(documents_dir)

    # 2. Build Accommodations CSV file.
    accommodations = @shelter.accommodations.includes(:animal_type, :location).all
    unless accommodations.blank?
      accommodations_file = File.join(@write_dir, "accommodations.csv")
      CSV.open(accommodations_file , "w+:UTF-8") do |csv|
        DataExport::AccommodationPresenter.as_csv(accommodations, csv)
      end
    end

    # 3. Build Animals CSV file.
    animals_file = File.join(@write_dir, "animals.csv")
    animals = @shelter.animals.includes(:animal_type, :animal_status).all
    unless animals.blank?
      CSV.open(animals_file , "w+:UTF-8") do |csv|
        DataExport::AnimalPresenter.as_csv(animals, csv)
      end
    end

    # 4. Build Contacts CSV file.
    contacts_file = File.join(@write_dir, "contacts.csv")
    contacts = @shelter.contacts.all
    unless contacts.blank?
      CSV.open(contacts_file , "w+:UTF-8") do |csv|
        DataExport::ContactPresenter.as_csv(contacts, csv)
      end
    end

    # 5. Build Notes CSV file.
    notes_file = File.join(@write_dir, "notes.csv")
    notes = @shelter.notes.includes(:notable, :documents).all
    unless notes.blank?
      CSV.open(notes_file , "w+:UTF-8") do |csv|
        DataExport::NotePresenter.as_csv(notes, csv)
      end

      # Fetch documents and write with original filename.
      notes.each do |note|
        note.documents.each do |document|
          document_uri = URI(document.document.url)
          new_document_filename = File.join(documents_dir, document.original_name)

          open(new_document_filename, 'wb') do |file|
            file << open(document_uri).read
          end
        end
      end
    end

    # 6. Build Photos CSV file.
    photos_file = File.join(@write_dir, "photos.csv")
    photos = Photo.where(:attachable_id => animals.collect(&:id), :attachable_type => "Animal").all
    unless photos.blank?
      CSV.open(photos_file , "w+:UTF-8") do |csv|
        DataExport::PhotoPresenter.as_csv(photos, csv)
      end

      # Fetch photos and write with original filename.
      photos.each do |photo|
        photo_uri = URI(photo.image.url)
        new_photo_filename = File.join(photos_dir, photo.original_name)

        open(new_photo_filename, 'wb') do |file|
          file << open(photo_uri).read
        end
      end
    end

    # 7. Build Status Histories CSV file.
    status_histories_file = File.join(@write_dir, "status_histories.csv")
    status_histories = @shelter.status_histories.includes(:animal_status).all
    unless status_histories.blank?
      CSV.open(status_histories_file , "w+:UTF-8") do |csv|
        DataExport::StatusHistoryPresenter.as_csv(status_histories, csv)
      end
    end

    # 8. Build Tasks CSV file.
    tasks_file = File.join(@write_dir, "tasks.csv")
    tasks = @shelter.tasks.all
    unless tasks.blank?
      CSV.open(tasks_file , "w+:UTF-8") do |csv|
        DataExport::TaskPresenter.as_csv(tasks, csv)
      end
    end

    # 9. Add all files to the zip file.
    file_count = Dir.glob(File.join(@write_dir, "**", "*")).select { |file| File.file?(file) }.count
    if file_count > 0
      Zip::File.open(@uploaded_file, Zip::File::CREATE) do |zipfile|
        Dir.glob(File.join(@write_dir, "**", "*")).reject {|fn| File.directory?(fn) }.each do |file|
          zipfile.add(file.sub(@write_dir + '/', ''), file)
        end
      end

      # 10. Upload zip file to S3
      fog_file_path = "data_export/#{@zip_filename}"
      storage = Fog::Storage.new({
        :provider              => 'AWS',
        :aws_access_key_id     => ShelterExchange.settings.aws_access_key_id,
        :aws_secret_access_key => ShelterExchange.settings.aws_secret_access_key
      })
      directories = storage.directories.get(ShelterExchange.settings.s3_bucket)
      directories.files.create(
        :key => fog_file_path,
        :body => open(@uploaded_file).read,
        :public => false,
        :content_type => Mime::ZIP
      )

      # 11. Send email to notify the completion of the data export.
      DataExportMailer.completed(@shelter).deliver
    end

  rescue => e
    DataExportJob.logger.error("#{@shelter.id} :: #{@shelter.name} :: failed :: #{e.message}")
  ensure
    FileUtils.rm_rf @write_dir if @write_dir
    FileUtils.rm_rf @uploaded_file if @uploaded_file
    DataExportJob.logger.info("#{@shelter.id} :: #{@shelter.name} :: data export finished in #{Time.now - @start_time}")
  end

  def self.logger
    @logger ||= begin
      case ENV["RAILS_ENV"] || ENV["RAKE_ENV"]
      when "test"
        Logger.new(nil)
      when "development"
        Logger.new($stdout)
      else
        Logger.new(File.join(Rails.root, "log", "data_export_job.log"))
      end
    end
  end
end

