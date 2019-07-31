require_relative 'boot'

require "active_model/railtie"
require "action_controller/railtie"
require "action_cable/engine"
require "action_view/railtie"
require "sprockets/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

Dotenv::Railtie.load

module Spoonly
  class Application < Rails::Application
    config.load_defaults 5.2

    config.autoload_paths += [
      Rails.root.join('app', 'services'),
    ]
  end
end
