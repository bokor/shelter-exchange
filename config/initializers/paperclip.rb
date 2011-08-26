if Rails.env.development? or Rails.env.test?
  Paperclip.options[:command_path] = "/usr/local/bin" 
else
  Paperclip.options[:command_path] = "/usr/bin" 
end