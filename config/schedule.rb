# All Integrations every day at 2:00am
every 1.day, :at => '2:00 am' do
  rake "integrations:start"
end

# Refresh Sitemap and Ping Search Engines
every 2.hours do
  rake "sitemap:refresh"
end

# Clean up Data export zip files.
every 1.hour do
  rake "data_export:clean"
end


