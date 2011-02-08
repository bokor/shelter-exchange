# require ENV_PATH
# 
# class String
#   # http://www.devarticles.com/c/a/Development-Cycles/Tame-the-Beast-by-Matching-Similar-Strings/3/
#   module Soundex
#     Codes = {
#       'b' => 1,
#       'f' => 1,
#       'p' => 1,
#       'v' => 1,
#       'c' => 2,
#       'g' => 2,
#       'j' => 2,
#       'k' => 2,
#       'q' => 2,
#       's' => 2,
#       'x' => 2,
#       'z' => 2,
#       'd' => 3,
#       't' => 3,
#       'l' => 4,
#       'm' => 5,
#       'n' => 5,
#       'r' => 6
#     }
#   end
# 
#   def phonetic_code
#     chars = self.split(//)
#     initial = chars.shift.upcase
#     chars.map { |c| Soundex::Codes[c.downcase] }.flatten.unshift(initial).to_s
#   end
# 
#   def remove_color_codes
#     self.gsub(/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]/, '')
#   end
# end
# 
# @codes = {}
# 
# File.open(ActiveRecord::Base.logger.instance_eval { @logdev }.filename, 'r') do |f|
#   f.each_line do |line|
#     if line.match(/ SELECT /)
#       l = 'SELECT' + line.remove_color_codes.split('SELECT').last
#       @codes[l.phonetic_code] = l
#     end
#   end
# end
# 
# bad_queries = @codes.values.select do |query|
#   ActiveRecord::Base.connection.select_all("EXPLAIN #{query}").any? do |result|
#     result['key'].nil?
#   end
# end
# 
# puts bad_queries