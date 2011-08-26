# config/initializers/delayed_job_config.rb
Delayed::Worker.destroy_failed_jobs = false
#Delayed::Worker.sleep_delay = 60
Delayed::Worker.max_attempts = 3
Delayed::Worker.max_run_time = 5.minutes
# if Rails.env.staging? or Rails.env.demo? or Rails.env.test?
#   Delayed::Worker.delay_jobs = false
# else
#   Delayed::Worker.delay_jobs = true
# end