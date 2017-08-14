# config/initializers/delayed_job_config.rb
Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.max_attempts = 3
Delayed::Worker.read_ahead = 10
Delayed::Worker.max_run_time = 30.minutes
Delayed::Worker.delay_jobs = !Rails.env.test?

