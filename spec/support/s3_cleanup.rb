# RSpec.configure do |config|
# 
#   config.after :suite do 
#     if Rails.env.test? && FOG_BUCKET.key == 'shelterexchange-test'
#       FOG_BUCKET.files.all.each do |file|
#         file.destroy
#       end
#     end
#   end
# end