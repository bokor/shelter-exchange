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

    ::STATS_DIRECTORIES << ["Views",                "app/views",                 /\.erb$/]
    ::STATS_DIRECTORIES << ["Stylesheets - Admin",  "public/stylesheets/admin",  /\.css$/]
    ::STATS_DIRECTORIES << ["Stylesheets - API",    "public/stylesheets/api",    /\.css$/]
    ::STATS_DIRECTORIES << ["Stylesheets - App",    "public/stylesheets/app",    /\.css$/]
    ::STATS_DIRECTORIES << ["Stylesheets - Global", "public/stylesheets/global", /\.css$/]
    ::STATS_DIRECTORIES << ["Stylesheets - Public", "public/stylesheets/public", /\.css$/]
    ::STATS_DIRECTORIES << ["Javascript - Admin",   "public/javascripts/admin",  /\.js$/]
    ::STATS_DIRECTORIES << ["Javascript - API",     "public/javascripts/api",    /\.js$/]
    ::STATS_DIRECTORIES << ["Javascript - Public",  "public/javascripts/public", /\.js$/]
    ::STATS_DIRECTORIES << ["Javascript - Shared",  "public/javascripts/shared", /\.js$/]
    #::STATS_DIRECTORIES << ['CSS',  'app/assets/stylesheets', /\.css$/]
    #::STATS_DIRECTORIES << ['JS',  'app/assets/javascripts', /\.js$/]
  end
end
task :stats => "spec:statsetup"
