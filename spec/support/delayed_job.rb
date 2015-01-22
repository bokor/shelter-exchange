RSpec.configure do |config|
  config.around(:each, :delayed_job) do |example|
    old_value = Delayed::Worker.delay_jobs
    Delayed::Worker.delay_jobs = true
    Delayed::Job.delete_all

    example.run

    Delayed::Worker.delay_jobs = old_value
  end
end

