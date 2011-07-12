# files = []
#     files << ['assets']
#     files << ['javascripts', 'compiled']
#     files << ['stylesheets', 'compiled']
#     files = files.map { |path| Dir[Rails.root.join('public', *path, '*.*')] }.flatten
#     
#     puts "Removing:"
#     files.each do |file|
#       puts "  #{file.gsub(Rails.root.to_s + '/', '')}"
#     end
#     
#     File.delete *files

# Set Current TimeZone
run "ln -sf /usr/share/zoneinfo/US/Eastern /usr/share/zoneinfo/localtime"

# Remove Generated Assets
sudo "rm #{current_path}/public/assets/*"

# Run Jammit-s3
run "cd #{current_path} && bundle exec jammit-s3"

# Restart Delayed Job
sudo "monit -g dj_shelter_exchange_app restart all"



