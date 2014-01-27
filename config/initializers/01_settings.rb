module ShelterExchange

  def self.settings
    ShelterExchangeApp::Application.config
  end

  def self.features
    ShelterExchangeApp::Application.config.features
  end
end

module ShelterExchangeApp
  class Application < Rails::Application

    # Helper for loading deeply nested environment config.
    def load_env(context, key, value)
      if value.is_a?(Hash)
        options = begin
          context.send(key) || ActiveSupport::OrderedOptions.new
        rescue
          ActiveSupport::OrderedOptions.new
        end

        context.send("#{key}=", options)

        value.each do |k, v|
          load_env(options, k, v)
        end
      else
        context.send("#{key}=", value)
      end
    end

    # Load environment settings from yaml files.
    ["config/settings.yml", "config/features.yml"].each do |path|
      yml = YAML.load_file(Rails.root.join(path))[Rails.env]
      yml && yml.each{|key, value| load_env(config, key, value) }
    end

  end
end

