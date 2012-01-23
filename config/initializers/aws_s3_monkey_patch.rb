# module AWS
#   module S3
#     class Connection 
#       
#       def url_for(path, options = {})
#         authenticate = options.delete(:authenticated)
#         # Default to true unless explicitly false
#         authenticate = true if authenticate.nil? 
#         path         = self.class.prepare_path(path)
#         request      = request_method(:get).new(path, {})
#         query_string = query_string_authentication(request, options)
#         "#{protocol(options)}#{http.address}#{port_string}#{path}".tap do |url|
#           url << "?#{query_string}" if authenticate
#         end
#       end
#       
#     end
#   end
# end
# 
# class String
#   def tap
#     yield(self)
#     self
#   end unless ''.respond_to?(:tap)
# end 