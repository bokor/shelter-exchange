require 'uri'
##
# CarrierWave Amazon S3 File Reprocessor Rake Task
#
# Written (specifically) for:
# - CarrierWave
# - Ruby on Rails 3
# - Amazon S3
#
# Works with:
# - Any server of which you have write-permissions in the Rails.root/tmp directory
# - Works with Heroku
#
# Not tested with, but might work with:
# - Ruby on Rails 2
#
# Might work with, after a couple of tweaks:
# - File System Storage
# - Cloud Files Storage
# - GridFS
#
# Examples:
#
# Reprocess all versions of User#avatar
#  rake carrierwave:reprocess class=User mounted_uploader=avatar
#
# Embeds One (picture) Association
#  rake carrierwave:reprocess class=User association=picture mounted_uploader=image versions='thumb, small, medium'
#
# Embeds Many (pictures) Association
#  rake carrierwave:reprocess class=User association=pictures mounted_uploader=image versions='thumb, small, medium'
#
# WARNING
# There is an issue with "Rake", that you cannot name your mounted_uploader "file".
# If you do this, then you will not be able to reprocess images through this rake task
#  class User
#    include Mongoid::Document
#    mount_uploader :file, PictureUploader
#  end
#
# This will NOT work with reprocessing through Rake because the mounted_uploader uses the "file" attribute.

namespace :carrierwave do

  ##
  # Only tested with Amazon S3 Storage
  # Needs some minor modifications if you want to use this for File System Store, Cloud Files and GridFS probably.
  # This should work without Ruby on Rails as well, just set a different TMP_PATH.
  desc "Reprocesses Carrier Wave file versions of a given model."
  task :reprocess => :environment do

    ##
    # Default constants
    # TMP_PATH          = "#{Rails.root}/tmp/carrierwave"

    ##
    # Set environment constants
    CLASS             = ENV['class'].capitalize
    ASSOCIATION       = ENV['association'] || nil
    MOUNTED_UPLOADER  = ENV['mounted_uploader'].to_sym
    VERSIONS          = ENV['versions'].nil? ? Array.new : ENV['versions'].split(',').map {|version| version.strip.to_sym}

    ##
    # Find the Model
    MODEL = Kernel.const_get(CLASS)

    ##
    # Create the temp directory
    # %x(mkdir -p "#{TMP_PATH}")

    ##
    # Output to console
    puts "\nCarrier Wave Version Reprocessing!"
    puts "======================================="
    puts "Model:              #{CLASS}"
    puts "Mounted Uploader:   #{MOUNTED_UPLOADER}"
    puts "Association:        #{ASSOCIATION}" if ASSOCIATION
    puts "Versions:           #{VERSIONS.empty? ? "all" : VERSIONS.join(', ')}\n\n"

    ##
    # Find all records for the provided Model - in batch mode
    MODEL.reorder(:id).find_each(:batch_size =>  50) do |record|

      ##
      # Set the mounted uploader object
      # If it has a one-to-one association (singular) then that object
      # will be returned and wrapped in an array so we can "iterate" through it below.
      #
      # If it has a one-to-many association then it will return the array of associated objects
      #
      # If no association is specified, it assumes the amounted uploader is attached to the specified CLASS
      if ASSOCIATION
        if ASSOCIATION.singular?
          objects = [record.send(ASSOCIATION)]
        else
          objects = record.send(ASSOCIATION)
        end
      else
        objects = [record]
      end

      ##
      # Iterates through the objects
      objects.each do |object|

        ##
        # Returns the mounted uploader object
        mounted_object = object.send(MOUNTED_UPLOADER)

        object.generate_guid! # force create new guid for filename

        unless mounted_object.path.blank?

          # Get the File from S3
          begin
            mounted_object.cache_stored_file!
            mounted_object.retrieve_from_cache!(mounted_object.cache_name)
            mounted_object.recreate_versions!
          rescue => e
             puts  "ERROR: #{CLASS}: #{object.id} -> #{e.to_s}"
          end

          object.class.record_timestamps = false
          object.save!
          object.class.record_timestamps = true

          # log to output the filename being created
          puts  "Reprocessing: #{CLASS}: #{object.id} ->  #{mounted_object.filename} -> #{mounted_object.file.content_type}"

        end
      end
    end

  end
end
