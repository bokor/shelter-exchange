# Restart Delayed Job
restart_delayed_jobs = "monit -g dj_#{config.app} restart all"
case config.environment
when "production"
  on_utilities("background_jobs"){ sudo restart_delayed_jobs }
when "staging"
  sudo restart_delayed_jobs
end
