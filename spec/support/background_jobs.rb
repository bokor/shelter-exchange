# Configure RSpec request specs with a custom run_background_jobs_immediately method:
#
# RSpec.configure do |config|
#   # if you're using Capybara 1.x, :feature should be replaced with :request
#   config.around(:each, type: :feature) do |example|
#     run_background_jobs_immediately do
#       example.run
#     end
#   end
#
#   config.include BackgroundJobs
# end

# A Delayed::Job implementation of the method:
# module BackgroundJobs
#   def run_background_jobs_immediately
#     delay_jobs = Delayed::Worker.delay_jobs
#     Delayed::Worker.delay_jobs = false
#     yield
#     Delayed::Worker.delay_jobs = delay_jobs
#   end
# end

# A Resque implementation of the method:
# module BackgroundJobs
#   def run_background_jobs_immediately
#     inline = Resque.inline
#     Resque.inline = true
#     yield
#     Resque.inline = inline
#   end
# end

