if Rails.env.production?
  # All Integrations every day at 2:00am
  every 1.day, :at => '2:00 am' do
    rake "integrations:start"
  end

  # Ping Search Engines
  every 1.day, :at => '5:00 am' do
    rake "sitemap:ping"
  end
end

