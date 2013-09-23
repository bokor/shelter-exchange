if Rails.env.development?
  ActiveRecord::Base.connection.execute("TRUNCATE delayed_jobs")
end

