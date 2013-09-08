namespace :spec do

  desc "Adding all code for test coverage and see where to minimize code"
  task :statsetup do
    require 'rails/code_statistics'

    class CodeStatistics
      alias calculate_statistics_orig calculate_statistics
      def calculate_statistics
        @pairs.inject({}) do |stats, pair|
          if 3 == pair.size
            stats[pair.first] = calculate_directory_statistics(pair[1], pair[2]); stats
          else
            stats[pair.first] = calculate_directory_statistics(pair.last); stats
          end
        end
      end
    end

    ::STATS_DIRECTORIES << ["Views",        "app/views",              /\.erb$/]
    ::STATS_DIRECTORIES << ['Stylesheets',  'app/assets/stylesheets', /\.css$/]
    ::STATS_DIRECTORIES << ['Javascripts',  'app/assets/javascripts', /\.js$/]
  end
end
task :stats => "spec:statsetup"
