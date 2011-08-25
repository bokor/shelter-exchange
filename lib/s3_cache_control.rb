# module AWS
#   module S3
#     class S3Object
#       class << self
#         def store_with_cache_control(key, data, bucket = nil, options = {})
#           options["Cache-Control"] = 'max-age=315360000' if options["Cache-Control"].blank?
#           options["Expires"]       = 315360000.from_now.httpdate if options["Expires"].blank?
#           
#           store_without_cache_control(key, data, bucket, options)
#         end
# 
#         alias_method_chain :store, :cache_control
#       end
#     end
#   end
# end