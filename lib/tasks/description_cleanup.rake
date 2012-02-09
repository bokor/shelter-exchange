namespace :animal do
  
  desc "Clean up descriptions"
  task :cleanup => :environment do
    Animal.record_timestamps = false
    Animal.all.each do |animal|
      s = animal.description
      s = s.strip
      s = s.gsub(/[\u201C\u201D\u201E\u201F\u2033\u2036]/, '"') 
      s = s.gsub(/[\u2018\u2019\u201A\u201B\u2032\u2035\uFFFD]/, "'") 
      s = s.gsub(/[\u2013\u2014]/, "-") 
      s = s.gsub(/\u02C6/, '^')
      s = s.gsub(/\u2039/, '<')
      s = s.gsub(/\u203A/, '>')
      s = s.gsub(/\u2013/, '-')
      s = s.gsub(/\u2014/, '--')
      s = s.gsub(/\u2026/, '...')
      s = s.gsub(/\u00A9/, '&copy;')
      s = s.gsub(/\u00AE/, '&reg;')
      s = s.gsub(/\u2122/, '&trade;')
      s = s.gsub(/\u00BC/, '&frac14;')
      s = s.gsub(/\u00BD/, '&frac12;')
      s = s.gsub(/\u00BE/, '&frac34;')
      s = s.gsub(/[\u02DC\u00A0]/, " ")
      animal.update_attribute(:description, s)
    end
    Animal.record_timestamps = true
  end
  
end